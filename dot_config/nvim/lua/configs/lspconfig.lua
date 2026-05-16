require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "rust_analyzer", "kotlin_lsp", "jdtls", "taplo" }

vim.lsp.config("taplo", {
  root_markers = { ".taplo.toml", "taplo.toml", "Cargo.toml", ".git" },
})

vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
