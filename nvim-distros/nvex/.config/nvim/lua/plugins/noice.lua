return {
  "folke/noice.nvim",
  enabled = true,
  event = "VeryLazy",
  opts = {
    presets = {
      bottom_search = true,
      command_palette = false,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
    cmdline = {
      enabled = true,
      view = "cmdline",
    },
    lsp = {
      signature = {
        enabled = false,
        border = { style = "rounded" },
      },
    }
  },
  config = function(_, opts)
    require("noice").setup(opts)

    -- Custom highlight overrides
    local hl = vim.api.nvim_set_hl
    hl(0, "NoicePopup", { bg = "#292c3c" })
    -- -- hl(0, "NoicePopupBorder", { fg = "#89b4fa" })
    hl(0, "NoicePopupmenu", { bg = "#292c3c" })
    -- -- hl(0, "NoicePopupmenuSelected", { bg = "#313244", fg = "#cdd6f4" })
  end,
}
