return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    vim.schedule(function()
      local bufferline = require("bufferline")

      bufferline.setup({
        options = {
          tab_size = 6,
          style_preset = bufferline.style_preset.minimal,
          separator_style = { "", "" },
          show_buffer_close_icons = false,
          indicator = {
            style = "none",
          },
          themable = true,
        },
        highlights = {
          fill = {
            link = "TabLineFill",
          },
          background = {
            link = "TabLine",
          },
          buffer_selected = {
            bold = false,
            italic = false,
            link = "TabLineSel",
          },
          buffer_visible = {
            link = "TabLine",
          },
          numbers_selected = {
            bold = false,
            italic = false,
            fg = { attribute = "fg", highlight = "TabLineSel" },
          },
          diagnostic_selected = {
            bold = false,
            italic = false,
            fg = { attribute = "fg", highlight = "TabLineSel" },
          },
          hint_selected = {
            bold = false,
            italic = false,
            fg = { attribute = "fg", highlight = "TabLineSel" },
          },
          info_selected = {
            bold = false,
            italic = false,
            fg = { attribute = "fg", highlight = "TabLineSel" },
          },
          warning_selected = {
            bold = false,
            italic = false,
            fg = { attribute = "fg", highlight = "TabLineSel" },
          },
          error_selected = {
            bold = false,
            italic = false,
            fg = { attribute = "fg", highlight = "TabLineSel" },
          },
          modified_selected = {
            bold = false,
            italic = false,
            fg = { attribute = "fg", highlight = "TabLineSel" },
          },
          duplicate_selected = {
            bold = false,
            italic = false,
            fg = { attribute = "fg", highlight = "TabLineSel" },
          },
          pick_selected = {
            bold = false,
            italic = false,
            fg = { attribute = "fg", highlight = "TabLineSel" },
          },
        }
      })
    end)
  end,
}
