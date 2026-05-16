return {
  "kevinhwang91/nvim-ufo",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "kevinhwang91/promise-async",
  },
  config = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

    require("ufo").setup()
  end,
}
