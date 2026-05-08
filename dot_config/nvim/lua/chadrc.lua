-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

local light_theme = "catppuccin-latte"
local dark_theme = "catppuccin"
local dark_comment = "#A6ADC8"
local dark_subtle = "#9399B2"
local latte_comment = "#6C6F85"
local latte_subtle = "#7C7F93"

local function system_output(cmd)
  if vim.fn.executable(cmd[1]) ~= 1 then
    return nil
  end

  if vim.system then
    local ok, job = pcall(vim.system, cmd, { text = true })

    if not ok then
      return nil
    end

    local result = job:wait()
    return result.code == 0 and vim.trim(result.stdout or "") or nil
  end

  local lines = vim.fn.systemlist(cmd)
  return vim.v.shell_error == 0 and vim.trim(table.concat(lines, "\n")) or nil
end

local function desktop_color_scheme()
  local portal_output = system_output {
    "gdbus",
    "call",
    "--session",
    "--dest",
    "org.freedesktop.portal.Desktop",
    "--object-path",
    "/org/freedesktop/portal/desktop",
    "--method",
    "org.freedesktop.portal.Settings.Read",
    "org.freedesktop.appearance",
    "color-scheme",
  }
  local portal_value = portal_output
    and (
      portal_output:match "uint32%s+(%d+)"
      or portal_output:match "%f[%d]([012])%f[%D]"
    )

  if portal_value == "1" then
    return "dark"
  elseif portal_value == "2" then
    return "light"
  end

  local gnome_color_scheme = system_output {
    "gsettings",
    "get",
    "org.gnome.desktop.interface",
    "color-scheme",
  }

  if gnome_color_scheme then
    local value = gnome_color_scheme:lower()

    if value:find "dark" then
      return "dark"
    elseif value:find "light" or value:find "default" then
      return "light"
    end
  end

  return vim.o.background == "light" and "light" or "dark"
end

local selected_mode = desktop_color_scheme()
vim.o.background = selected_mode

M.base46 = {
  theme = selected_mode == "light" and light_theme or dark_theme,
  theme_toggle = { dark_theme, light_theme },
  transparency = true,
  changed_themes = {
    catppuccin = {
      base_30 = {
        light_grey = dark_comment,
      },
      base_16 = {
        base03 = dark_subtle,
        base04 = dark_comment,
      },
    },
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
    ["@comment"] = { fg = "light_grey" },
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
