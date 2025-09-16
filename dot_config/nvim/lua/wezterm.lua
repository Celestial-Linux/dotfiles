local wezterm_config = require "wezterm-config"
wezterm_config.set_wezterm_user_var("window_background_opacity", 0.96)

vim.api.nvim_create_autocmd("VimLeavePre", {
  group = vim.api.nvim_create_augroup("WeztermCleanup", { clear = true }),
  callback = function()
    wezterm_config.set_wezterm_user_var("window_background_opacity", 0.5)
  end,
})
