return {
  "nvim-lualine/lualine.nvim",
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto",
      section_separators = { left = "\u{e0bc}", right = "\u{e0be}" },
      component_separators = { left = "\u{e0bd}", right = "\u{e0bf}" },
      globalstatus = true,
      disabled_filetypes = {
        statusline = { "snacks_dashboard", "dashboard", "alpha", "starter" },
        winbar = {},
      },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        {
          "branch",
          icon = "", -- git branch icon
        },
      },
      lualine_c = {
        {
          "diagnostics",
          symbols = {
            error = " ", -- error icon
            warn = " ",  -- warning icon
            info = " ",  -- info icon
            hint = " ",  -- hint icon
          },
        },
        {
          "filetype",
          icon_only = true,
          separator = "",
          padding = { left = 1, right = 0 },
        },
        {
          "filename",
          path = 1,
          symbols = {
            modified = "● ",    -- filled circle
            readonly = " ",    -- lock icon
            unnamed = "[No Name]",
          },
        },
      },
      lualine_x = {
        {
          "diff",
          symbols = {
            added = " ",      -- plus icon
            modified = " ",   -- tilde/modified icon
            removed = " ",    -- minus icon
          },
        },
      },
      lualine_y = {
        { "progress", separator = " ", padding = { left = 1, right = 0 } },
        { "location", padding = { left = 0, right = 1 } },
      },
      lualine_z = {
        function()
          return " " .. os.date("%R")  -- clock icon
        end,
      },
    },
    extensions = { "neo-tree", "lazy" },
  },
}
