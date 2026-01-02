return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      transparent_background = true,
      float = {
        transparent = true,
      },
      styles = {
        comments = { "altfont" },
      },
      custom_highlights = function(colors)
        return {
          -- Comment = { fg = colors.flamingo },
          -- TabLineSel = { bg = colors.pink },
          -- CmpBorder = { fg = colors.surface2 },
          --
          -- Get some nice colors for pop up menus
          Pmenu = { bg = colors.surface0, fg = colors.text },
          PmenuSel = { bg = colors.mauve, fg = colors.base },
        }
      end
    })
    -- vim.cmd.colorscheme("catppuccin-mocha")
  end,

}
