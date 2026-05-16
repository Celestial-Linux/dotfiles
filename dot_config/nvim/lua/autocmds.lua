require "nvchad.autocmds"

local theme_sync_group = vim.api.nvim_create_augroup("nvim_system_theme_sync", { clear = true })

local function sync_system_theme()
  local ok, chadrc = pcall(require, "chadrc")

  if ok and type(chadrc.sync_system_theme) == "function" then
    chadrc.sync_system_theme()
  end
end

vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
  group = theme_sync_group,
  callback = sync_system_theme,
})
