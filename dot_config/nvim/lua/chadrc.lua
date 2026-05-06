-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

local light_theme = "catppuccin-latte"
local dark_theme = "catppuccin"
local latte_comment = "#6C6F85"
local latte_subtle = "#7C7F93"

M.base46 = {
  theme = vim.o.background == "light" and light_theme or dark_theme,
  theme_toggle = { dark_theme, light_theme },
  transparency = true,
  changed_themes = {
    catppuccin_latte = {
      base_30 = {
        light_grey = latte_comment,
      },
      base_16 = {
        base03 = latte_subtle,
        base04 = latte_comment,
      },
    },
  },
  hl_override = {
    Comment = { fg = "light_grey" },
    gitcommitComment = { fg = "light_grey" },
    gitcommitDiscarded = { fg = "light_grey" },
    gitcommitSelected = { fg = "light_grey" },
    gitcommitUntracked = { fg = "light_grey" },
    NonText = { fg = "grey_fg2" },
    SpecialKey = { fg = "grey_fg2" },
  },
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
