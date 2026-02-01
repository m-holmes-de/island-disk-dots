return {
  "olimorris/onedarkpro.nvim",
  priority = 1000, -- Ensure it loads first
  name = "onedarkpro",
  config = function()
    require("onedarkpro").setup({
      options = {
        transparency = true,
      },
    })
    vim.cmd("colorscheme onedark")
  end,
}
