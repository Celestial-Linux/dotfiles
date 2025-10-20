return {
  "williamboman/mason-lspconfig.nvim",
  event = "VeryLazy",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require "configs.mason-lspconfig"
  end,
}

