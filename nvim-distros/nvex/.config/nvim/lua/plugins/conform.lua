return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { lsp_format = "prefer" },
        -- Conform will run multiple formatters sequentially
        python = { "black" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
    })
  end,
}
