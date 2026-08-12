local M = {}

local prompted = {}
local notifications = {}
local protected = {}
local server_info = {}
local server_names = {}

-- Rust-analyzer's built-in root resolver runs `cargo metadata`.  Establish a
-- coarse trust boundary before allowing that resolver to inspect a project.
local preflight_markers = {
  rust_analyzer = { "Cargo.toml", "rust-project.json", ".git" },
}

local function fullpath(path)
  if type(path) ~= "string" or path == "" then
    return nil
  end

  return vim.uv.fs_realpath(vim.fs.normalize(path))
end

local function notify_once(key, message, level)
  if notifications[key] then
    return
  end

  notifications[key] = true
  vim.notify(message, level)
end

-- vim.secure.read() prompts for unknown paths.  Status must remain a
-- side-effect-free query, so inspect the documented trust database format
-- directly instead of calling it here.
local function persistent_status(path)
  local root = fullpath(path)
  if not root then
    return "unknown", nil
  end

  local trust_file = vim.fs.joinpath(vim.fn.stdpath "state", "trust")
  local file = io.open(trust_file, "r")
  if not file then
    return "unknown", root
  end

  for line in file:lines() do
    local hash, stored_path = line:match "^(%S+) (.+)$"
    if stored_path == root then
      file:close()
      return hash == "!" and "denied" or "allowed", root
    end
  end

  file:close()
  return "unknown", root
end

function M.status(path)
  local state, root = persistent_status(path)
  return state, root
end

local function reset_session(path)
  local root = fullpath(path)
  if root then
    prompted[root] = nil
    notifications["unknown:" .. root] = nil
    notifications["denied:" .. root] = nil
  end
end

local function stop_clients(root)
  local canonical = fullpath(root)
  if not canonical then
    return
  end

  for _, client in ipairs(vim.lsp.get_clients()) do
    if fullpath(client.config.root_dir) == canonical then
      client:stop()
    end
  end
end

-- Check and, when necessary, prompt for trust.  Returning false is the only
-- path on which a root callback is not invoked, so no LSP process can start.
function M.ensure(root, server_name)
  local state, canonical = persistent_status(root)
  if not canonical or vim.fn.isdirectory(canonical) ~= 1 then
    notify_once(
      "invalid:" .. tostring(root),
      ("LSP %s blocked: workspace root is not a directory: %s"):format(
        server_name or "server",
        tostring(root)
      ),
      vim.log.levels.WARN
    )
    return false
  end

  if state == "allowed" then
    prompted[canonical] = nil
    return true
  end

  if state == "denied" then
    notify_once(
      "denied:" .. canonical,
      ("LSP %s blocked: workspace is denied: %s (use :WorkspaceTrust to allow it)"):format(
        server_name or "server",
        canonical
      ),
      vim.log.levels.WARN
    )
    return false
  end

  -- A cancelled/ignored prompt is unknown for the rest of this session.  It
  -- must not be shown once per server when several servers share a root.
  if prompted[canonical] then
    notify_once(
      "unknown:" .. canonical,
      ("LSP %s blocked: workspace is not trusted: %s (use :WorkspaceTrust to allow it)"):format(
        server_name or "server",
        canonical
      ),
      vim.log.levels.INFO
    )
    return false
  end

  prompted[canonical] = true
  local ok, trusted = pcall(vim.secure.read, canonical)
  if ok and trusted == true then
    local after = persistent_status(canonical)
    if after == "allowed" then
      prompted[canonical] = nil
      return true
    end
  end

  local after = persistent_status(canonical)
  if after == "denied" then
    notify_once(
      "denied:" .. canonical,
      ("LSP %s blocked: workspace is denied: %s (use :WorkspaceTrust to allow it)"):format(
        server_name or "server",
        canonical
      ),
      vim.log.levels.WARN
    )
  else
    notify_once(
      "unknown:" .. canonical,
      ("LSP %s blocked: workspace is not trusted: %s (use :WorkspaceTrust to allow it)"):format(
        server_name or "server",
        canonical
      ),
      vim.log.levels.INFO
    )
  end

  return false
end

function M.guard_root(root, on_dir, server_name)
  if not root or root == "" then
    return false
  end

  if not M.ensure(root, server_name) then
    return false
  end

  if type(on_dir) == "function" then
    local canonical = fullpath(root)
    on_dir(canonical or root)
  end
  return true
end

local function wrap_server(name, config)
  if protected[name] then
    return
  end

  local original_root_dir = config.root_dir
  local root_markers = config.root_markers
  local preflight = preflight_markers[name]

  server_info[name] = {
    filetypes = config.filetypes,
    root_markers = root_markers,
    preflight_markers = preflight,
  }

  local guarded_root_dir
  if type(original_root_dir) == "function" then
    guarded_root_dir = function(bufnr, on_dir)
      if preflight then
        local candidate = vim.fs.root(bufnr, preflight)
        if candidate and not M.ensure(candidate, name .. " root resolver") then
          return
        end
      end

      original_root_dir(bufnr, function(root)
        M.guard_root(root, on_dir, name)
      end)
    end
  elseif type(original_root_dir) == "string" then
    guarded_root_dir = function(_, on_dir)
      M.guard_root(original_root_dir, on_dir, name)
    end
  elseif root_markers then
    guarded_root_dir = function(bufnr, on_dir)
      M.guard_root(vim.fs.root(bufnr, root_markers), on_dir, name)
    end
  else
    -- A server without a root resolver is not safe to activate under this
    -- policy because there is no exact workspace boundary to trust.
    guarded_root_dir = function() end
  end

  vim.lsp.config(name, { root_dir = guarded_root_dir })
  protected[name] = true
end

local function matches_filetype(filetypes, filetype)
  return not filetypes or vim.tbl_contains(filetypes, filetype)
end

function M.resolve_current_workspace(bufnr)
  bufnr = bufnr or 0

  local roots = {}
  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr }) do
    local root = fullpath(client.config.root_dir)
    if root and not vim.tbl_contains(roots, root) then
      roots[#roots + 1] = root
    end
  end
  if #roots == 1 then
    return roots[1]
  elseif #roots > 1 then
    return nil, "multiple active workspace roots; pass an explicit directory"
  end

  local filetype = vim.bo[bufnr].filetype
  for _, name in ipairs(server_names) do
    local info = server_info[name]
    if info and matches_filetype(info.filetypes, filetype) then
      local markers = info.root_markers or info.preflight_markers
      if markers then
        local root = vim.fs.root(bufnr, markers)
        if root then
          return fullpath(root)
        end
      end
    end
  end

  return nil, "could not resolve a workspace root; pass an explicit directory"
end

local function command_root(args)
  args = vim.trim(args or "")
  if args ~= "" then
    local path = vim.fn.fnamemodify(args, ":p")
    if vim.fn.isdirectory(path) ~= 1 then
      return nil, ("not a directory: %s"):format(path)
    end
    return fullpath(path)
  end

  return M.resolve_current_workspace(0)
end

local function manage_trust(action, opts)
  local root, err = command_root(opts.args)
  if not root then
    vim.notify("Workspace trust: " .. (err or "workspace root not found"), vim.log.levels.WARN)
    return
  end

  local ok, result = vim.secure.trust { action = action, path = root }
  if not ok then
    vim.notify(("Workspace trust %s failed for %s: %s"):format(action, root, result), vim.log.levels.ERROR)
    return
  end

  reset_session(root)
  if action == "allow" then
    vim.notify("Workspace trusted for LSP: " .. root, vim.log.levels.INFO)
    vim.lsp.enable(server_names)
  elseif action == "deny" then
    stop_clients(root)
    vim.notify("Workspace denied for LSP: " .. root, vim.log.levels.WARN)
  else
    stop_clients(root)
    vim.notify("Workspace trust removed; LSP remains blocked until reviewed: " .. root, vim.log.levels.INFO)
  end
end

local function show_status(opts)
  local root, err = command_root(opts.args)
  if not root then
    vim.notify("Workspace trust: " .. (err or "workspace root not found"), vim.log.levels.WARN)
    return
  end

  local state = M.status(root)
  local session_note = state == "unknown" and prompted[root] and " (prompt already dismissed this session)" or ""
  local level = state == "allowed" and vim.log.levels.INFO or vim.log.levels.WARN
  vim.notify(("Workspace trust for %s: %s%s"):format(root, state, session_note), level)
end

local function create_commands()
  local commands = {
    WorkspaceTrust = function(opts)
      manage_trust("allow", opts)
    end,
    WorkspaceDeny = function(opts)
      manage_trust("deny", opts)
    end,
    WorkspaceTrustRemove = function(opts)
      manage_trust("remove", opts)
    end,
    WorkspaceTrustStatus = show_status,
  }

  for name, callback in pairs(commands) do
    if vim.fn.exists(":" .. name) == 2 then
      vim.api.nvim_del_user_command(name)
    end
    vim.api.nvim_create_user_command(name, callback, {
      nargs = "?",
      complete = "dir",
      desc = "Manage LSP workspace trust (optional directory argument)",
    })
  end
end

function M.setup(names)
  names = names or {}
  server_names = vim.deepcopy(names)

  -- NvChad enables lua_ls from its defaults() helper.  Disable it before
  -- wrapping the config so no earlier enable can bypass the trust gate.
  vim.lsp.enable("lua_ls", false)

  for _, name in ipairs(server_names) do
    local config = vim.lsp.config[name]
    if config then
      wrap_server(name, config)
    else
      notify_once("missing-config:" .. name, "Workspace trust: no LSP config found for " .. name, vim.log.levels.WARN)
    end
  end

  create_commands()
end

return M
