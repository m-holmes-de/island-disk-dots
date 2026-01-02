return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = 'rafamadriz/friendly-snippets',

  -- use a release tag to download pre-built binaries
  version = '*',
  -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
  -- build = 'cargo build --release',
  -- If you use nix, you can build from source using latest nightly rust with:
  -- build = 'nix run .#build-plugin',

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    cmdline = {
      enabled = true,
      completion = {
        menu = {
          auto_show = true
        }
      }
    },
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- See the full "keymap" documentation for information on defining your own keymap.
    keymap = {
      preset = 'default',
      ['<C-d>'] = { 'show', 'show_documentation', 'hide_documentation' },
      -- ['<C-e>'] = { 'hide' },
      -- ['<C-y>'] = { 'select_and_accept' },
      --
      -- ['<Up>'] = { 'select_prev', 'fallback' },
      -- ['<Down>'] = { 'select_next', 'fallback' },
      -- ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
      -- ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
      --
      -- ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      -- ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
      --
      -- ['<Tab>'] = { 'snippet_forward', 'fallback' },
      -- ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      --
      -- ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },

    },

    -- Blink supports signature help, automatically triggered when typing trigger characters, defined by the LSP, such as ( for lua. The menu will be updated when pressing a retrigger character, such as ,. Due to it being experimental, this feature is opt-in.
    signature = {
      enabled = true,
      window = {
        border = "rounded",
        show_documentation = false
      }
    },

    completion = {
      menu = {
        border = "rounded",
        draw = {
          gap = 1,
          treesitter = { "lsp" },
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { "kind" } },
        },
      },
      documentation = {
        auto_show = false, -- just use C-Space to view/hide
        auto_show_delay_ms = 1500,
        window = { border = "rounded" },
      }
    },
    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- Will be removed in a future release
      use_nvim_cmp_as_default = true,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono'
    },
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      providers = {
        -- markdown = {
        --   name = 'RenderMarkdown',
        --   module = 'render-markdown.integ.blink',
        --   fallbacks = { 'lsp' },
        -- },
      },
    },
  },
  opts_extend = { "sources.default" },
  config = function(_, opts)
    require("blink.cmp").setup(opts)
    -- Highlight override for cmp menu background
    vim.api.nvim_set_hl(0, "BlinkCmpMenu", { fg = "#cdd6f4" })                          -- catppuccin-mocha bg.surface0, fg.text
    vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#cba6f7", fg = "#1e1e2e" }) -- catppuccin-mocha bg.mauve, fg.base
    -- vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#292c3c" })
    -- vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { bg = "#292c3c" })
  end,
}
