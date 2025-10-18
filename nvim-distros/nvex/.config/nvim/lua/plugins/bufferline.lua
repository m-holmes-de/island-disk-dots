return
{
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({
      options = {
        tab_size = 6,
        style_preset = bufferline.style_preset.minimal,
        separator_style = { "", "" },
        show_buffer_close_icons = false,
        indicator = {
          -- icon = ' ',
          -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
          style = "none",
        },
      },
      highlights = {
        buffer_selected = {
          bold = false,
          italic = false,
          fg = "#e0af68", -- Different color for active buffer (golden yellow)
          -- bg = "#181926", -- Different color for active buffer (golden yellow)
        },
        numbers_selected = {
          bold = false,
          italic = false,
          fg = "#e0af68",
        },
        diagnostic_selected = {
          bold = false,
          italic = false,
          fg = "#e0af68",
        },
        hint_selected = {
          bold = false,
          italic = false,
          fg = "#e0af68",
        },
        info_selected = {
          bold = false,
          italic = false,
          fg = "#e0af68",
        },
        warning_selected = {
          bold = false,
          italic = false,
          fg = "#e0af68",
        },
        error_selected = {
          bold = false,
          italic = false,
          fg = "#e0af68",
        },
        modified_selected = {
          bold = false,
          italic = false,
          fg = "#e0af68",
        },
        duplicate_selected = {
          bold = false,
          italic = false,
          fg = "#e0af68",
        },
        pick_selected = {
          bold = false,
          italic = false,
          fg = "#e0af68",
        },
      }
    })
  end,
}
