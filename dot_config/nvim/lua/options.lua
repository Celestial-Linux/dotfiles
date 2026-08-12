require "nvchad.options"

local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
o.exrc = false -- never execute project-local Neovim configuration
o.modeline = false -- do not accept buffer-local settings from untrusted files
o.expandtab = true -- expand tab input with spaces characters
o.smartindent = true -- syntax aware indentations for newline inserts
o.tabstop = 4 -- num of space characters per tab
o.shiftwidth = 4 -- spaces per indentation level
