-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

local light_theme = "catppuccin-latte"
local dark_theme = "catppuccin"

M.base46 = {
  theme = vim.o.background == "light" and light_theme or dark_theme,
  theme_toggle = { dark_theme, light_theme },
  transparency = true,
}

M.nvdash = {
  load_on_startup = true,
  header = {
    " __      _____ ",
    "|  | ___/ ____\\",
    "|  |/ /\\   __ ",
    "|    <  |  |   ",
    "|__|_ \\ |__|   ",
    "     \\/        ",
  },
}

return M
