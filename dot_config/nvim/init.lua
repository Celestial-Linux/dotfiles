vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
local lazy_commit = "306a05526ada86a7b30af95c5cc81ffba93fef97"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"

  local function git(args)
    local output = vim.fn.system(args)

    if vim.v.shell_error ~= 0 then
      error("Failed to bootstrap lazy.nvim:\n" .. output)
    end
  end

  git { "git", "init", lazypath }
  git { "git", "-C", lazypath, "remote", "add", "origin", repo }
  git { "git", "-C", lazypath, "fetch", "--filter=blob:none", "--depth=1", "origin", lazy_commit }
  git { "git", "-C", lazypath, "checkout", "--detach", "FETCH_HEAD" }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "git")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
