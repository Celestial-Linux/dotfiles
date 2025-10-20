local ok_mason_lsp, mason_lsp = pcall(require, "mason-lspconfig")
if not ok_mason_lsp then
  return
end

-- Keep in sync with lua/configs/lspconfig.lua servers
-- Map any aliases to lspconfig server IDs for mason-lspconfig
local servers = {
  "html",
  "cssls",
  "rust_analyzer",
  "jdtls",
  -- kotlin: use JetBrains' kotlin_lsp
  "kotlin_lsp",
}

-- Optional: init mason if not already set up by NvChad
pcall(function()
  require("mason").setup()
end)

mason_lsp.setup {
  ensure_installed = servers,
  automatic_installation = true,
}

-- mason-nvim-dap: manage debuggers via Mason (centralized here)
pcall(function()
  require("mason-nvim-dap").setup {
    automatic_installation = true,
    handlers = {},
  }
end)
