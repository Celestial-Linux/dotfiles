# Repository Guidelines

## Project Structure & Module Organization
- Entry point `init.lua` bootstraps lazy.nvim and NvChad.
- Core config: `lua/options.lua`, `lua/mappings.lua`, `lua/autocmds.lua`, `lua/wezterm.lua`.
- Plugin specs live in `lua/plugins/*.lua`; per‑plugin settings go in `lua/configs/*.lua` (e.g., `plugins/conform.lua` + `configs/conform.lua`).
- LSP servers are declared/enabled in `lua/configs/lspconfig.lua`.
- Plugin versions are pinned in `lazy-lock.json`.

## Build, Test, and Development Commands
- First‑time setup: `nvim --headless '+Lazy! sync' +qa` (installs/updates plugins).
- In‑editor: `:Lazy sync` to update, `:Lazy check` to review, `:checkhealth` for diagnostics, `:LspInfo` to inspect LSP state.
- Format Lua: `:Format` (conform.nvim). CLI alternative: `stylua lua/` if available.
- Quick reload: `:luafile %` for the current Lua file; for broader changes, restart Neovim.

## Coding Style & Naming Conventions
- Lua: 2‑space indent; snake_case for filenames and locals; avoid globals; return a table from modules.
- Keep plugin and config filenames aligned (e.g., `treesitter.lua`, `lspconfig.lua`, `conform.lua`).
- Prefer idiomatic Neovim Lua APIs over Vimscript. Use Conform + Stylua for formatting.

## Testing Guidelines
- No unit test suite; validate changes manually:
  - Open a representative filetype and confirm LSP attaches (`:LspInfo`).
  - Run `:Format` and save to verify `BufWritePre` formatting.
  - Run `:checkhealth nvim-treesitter` to confirm parser status.

## Commit & Pull Request Guidelines
- Use Conventional Commits: `feat`, `fix`, `chore`, `docs`, etc. Example: `feat(lsp): enable kotlin_lsp`.
- Keep PRs focused; include a brief rationale, affected files, and screenshots for UI/statusline/theme changes.
- Commit `lazy-lock.json` only when plugin updates are intentional and verified.

## Agent‑Specific Notes
- Scope: this entire directory. Do not restructure; add new plugins under `lua/plugins/` with matching config in `lua/configs/` when needed.
- Prefer minimal, targeted diffs; keep style consistent with existing modules.

