local opts = {
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
  },
  appearance = {
    -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones)
    kind_icons = {
      Text = "󰉿",
      Method = "󰊕",
      Function = "󰊕",
      Constructor = "󰒓",

      Field = "󰜢",
      Variable = "󰆦",
      Property = "󰖷",

      Class = "󱡠",
      Interface = "󱡠",
      Struct = "󱡠",
      Module = "󰅩",

      Unit = "󰪚",
      Value = "󰦨",
      Enum = "󰦨",
      EnumMember = "󰦨",

      Keyword = "󰻾",
      Constant = "󰏿",

      Snippet = "󱄽",
      Color = "󰏘",
      File = "󰈔",
      Reference = "󰬲",
      Folder = "󰉋",
      Event = "󱐋",
      Operator = "󰪚",
      TypeParameter = "󰬛",
    },
  },
}

return opts
