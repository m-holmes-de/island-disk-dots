return {
  enabled = false,
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = {
    files = {
      hidden = false,
    }
  },
  keys = {
    {
      "<leader>sf", function() require("fzf-lua").files() end, desc = "[S]earch [F]iles",
    },
    {
      "<leader><leader>", function() require("fzf-lua").buffers() end, desc = "[S]search [B]uffers",
    },
    {
      "<leader>sg", function() require("fzf-lua").live_grep() end, desc = "[S]earch by [G]rep",
    },
    {
      "<leader>sh", function() require("fzf-lua").helptags() end, desc = "[S]search [H]elp",
    },
    {
      "<leader>sk", function() require("fzf-lua").keymaps() end, desc = "[S]search [K]eymaps",
    },
  },
}
