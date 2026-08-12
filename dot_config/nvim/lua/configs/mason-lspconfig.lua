local ok_mason_lsp, mason_lsp = pcall(require, "mason-lspconfig")
if not ok_mason_lsp then
  return
end

mason_lsp.setup {
  automatic_installation = false,
}

-- mason-nvim-dap: manage debuggers via Mason (centralized here)
pcall(function()
  require("mason-nvim-dap").setup {
    automatic_installation = false,
    handlers = {},
  }
end)
