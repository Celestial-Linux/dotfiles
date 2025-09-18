return {
  "winter-again/wezterm-config.nvim",
  config = function()
    require("wezterm-config").setup {
      append_wezterm_to_rtp = false,
    }
  end,
}

