return {
  'OXY2DEV/markview.nvim',
  lazy = false, -- Recommended

  dependencies = {
    -- You will not need this if you installed the
    -- parsers manually
    -- Or if the parsers are in your $RUNTIMEPATH
    'nvim-treesitter/nvim-treesitter',

    'nvim-tree/nvim-web-devicons',
  },
  config = {
    experimental = { check_rtp_message = false },
    preview = {
      enable = true,
      enable_hybrid_mode = true,
      modes = { 'i', 'n', 'no', 'c' },
      hybrid_modes = { 'i', 'n' },
      linewise_hybrid_mode = true,
    },
  },
}
