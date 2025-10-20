return {
  { import = "nvchad.blink.lazyspec" },
  {
    "Saghen/blink.cmp",
    opts = require "configs.blink",
    dependencies = {
      {
        "giuxtaposition/blink-cmp-copilot",
        dependencies = {
          { "zbirenbaum/copilot.lua" },
        },
        config = function()
          require("copilot").setup {
            suggestion = { enabled = false },
            panel = { enabled = false },
          }
        end,
      },
    },
  },
}
