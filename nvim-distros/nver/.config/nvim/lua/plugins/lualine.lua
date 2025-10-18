return {
  "nvim-lualine/lualine.nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  -- setup = function()
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status") -- to configure lazy pending updates count
    local custom_auto = require("lualine.themes.auto")
    -- custom_auto.normal.a.bg = '#112233'
    -- custom_auto.normal.b.bg = '#112233'
    -- custom_auto.normal.c.bg = '#292c3c' -- only add this using frappe
    -- custom_auto.normal.c.bg = '#181926' -- only add this using mocha
    -- custom_auto.normal.c.bg = '#191724' -- only valid if using rose-pine
    -- custom_auto.normal.c.bg = 'NONE' -- only use this if wanting a transparent background
    -- Set custom background for all modes
    -- local custom_bg = '#191724'

    -- Apply to all mode types
    -- for _, mode in pairs({ 'normal', 'insert', 'visual', 'replace', 'command', 'inactive' }) do
    --   if custom_auto[mode] and custom_auto[mode].c then
    --     custom_auto[mode].c.bg = custom_bg
    --   end
    -- end

    lualine.setup({

      options = {
        theme = custom_auto,
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
        disabled_filetypes = {},
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          {
            'filetype',
            colored = true,             -- Displays filetype icon in color if set to true
            icon_only = true,           -- Display only an icon for filetype
            icon = { align = 'right' }, -- Display filetype icon on the right hand side
            padding = { left = 1, right = 1 },
            -- icon =    {'X', align='right'}
            -- Icon string ^ in table is ignored in filetype component
          },
          "diagnostics"
        },
        lualine_c = {
        },
        lualine_x = {
          {
            "lsp_status",
            icons_enabled = false,
            color = { fg = "#81c8be" },
            colored = true,
            padding = { left = 1, right = 1 },
          },
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            padding = { left = 1, right = 1 },
            color = { fg = "#ff9e64" },
          },
        },
        lualine_y = {
          {
            "progress",
            separator = " ",
            padding = { left = 1, right = 0 }
          },
          { "location", padding = { left = 0, right = 1 } },
          {
            "diff",
            padding = { left = 0, right = 1 },
          },
        },
        lualine_z = {
          "branch",
        },
      },
    })
  end,

}
