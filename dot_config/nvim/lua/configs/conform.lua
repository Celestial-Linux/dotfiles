local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    json = { "deno_fmt" },
    jsonc = { "deno_fmt" },
    -- css = { "prettier" },
    -- html = { "prettier" },
  },

  formatters = {
    -- deno fmt defaults to 2 spaces; follow the buffer's indent instead
    deno_fmt = {
      append_args = function(_, ctx)
        return {
          "--indent-width",
          tostring(ctx.shiftwidth),
          "--use-tabs=" .. tostring(not vim.bo[ctx.buf].expandtab),
        }
      end,
    },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format { async = true, lsp_format = "fallback", range = range }
end, { range = true })

return options
