return {
  {
    'saghen/blink.cmp',
    dependencies = {
      { 'rafamadriz/friendly-snippets' },
    },
    version = 'v0.*',
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      signature = {
        enabled = true,
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        ghost_text = {
          enabled = true,
        },
        menu = {
          draw = {
            treesitter = { 'lsp' },
            columns = {
              { 'kind_icon', gap = 1 },
              { 'label', 'label_description', gap = 1 },
              { 'kind' },
            },
          },
        },
      },
    },
    opts_extend = { 'sources.default' },
  },
}
