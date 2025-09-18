require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "rust_analyzer", "kotlin_lsp", "jdtls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
