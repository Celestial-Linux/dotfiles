local servers = { "html", "cssls", "rust_analyzer", "kotlin_lsp", "jdtls", "taplo" }

vim.lsp.config("taplo", {
  root_markers = { ".taplo.toml", "taplo.toml", "Cargo.toml", ".git" },
})

local workspace_trust = require "configs.workspace_trust"
workspace_trust.setup(vim.list_extend(vim.deepcopy(servers), { "lua_ls" }))

require("nvchad.configs.lspconfig").defaults()

vim.lsp.enable(vim.list_extend(servers, { "lua_ls" }))

-- read :h vim.lsp.config for changing options of lsp servers
