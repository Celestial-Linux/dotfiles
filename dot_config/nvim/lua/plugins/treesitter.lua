local parsers = {
  "vim",
  "lua",
  "luadoc",
  "printf",
  "vimdoc",
  "query",
  "toml",
  "html",
  "css",
  "markdown",
  "markdown_inline",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    install_dir = vim.fn.stdpath "data" .. "/site",
  },
  config = function(_, opts)
    pcall(function()
      dofile(vim.g.base46_cache .. "syntax")
      dofile(vim.g.base46_cache .. "treesitter")
    end)

    local treesitter = require "nvim-treesitter"
    treesitter.setup(opts)

    if treesitter.install then
      treesitter.install(parsers)
    else
      require("nvim-treesitter.install").ensure_installed(parsers)
    end
  end,
}
