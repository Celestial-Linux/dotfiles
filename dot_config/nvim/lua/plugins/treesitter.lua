return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
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
  end,
}
