return {
  "mason-org/mason-lspconfig.nvim",
  event = "VeryLazy",
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = function(_, opts)
        opts.registry_cache = opts.registry_cache or {}
        opts.registry_cache.refresh = false
      end,
    },
  },
  config = function()
    require "configs.mason-lspconfig"
  end,
}
