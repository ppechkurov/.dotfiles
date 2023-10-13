return {
  -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
    {
      'HiPhish/nvim-ts-rainbow2',
      config = function()
        ---@diagnostic disable-next-line: missing-fields
        require('nvim-treesitter.configs').setup {
          incremental_selection = {
            enable = true,
            keymaps = {
              node_incremental = "v",
              node_decremental = "V",
            },
          },
          rainbow = {
            enable = true,
            -- list of languages you want to disable the plugin for
            -- disable = { "jsx", "cpp" },
            -- Which query to use for finding delimiters
            query = 'rainbow-parens',
            -- Highlight the entire buffer all at once
            strategy = require 'ts-rainbow.strategy.global',
          },
        }

        vim.api.nvim_create_autocmd({ 'BufWritePost', 'FocusGained' }, {
          callback = function()
            vim.cmd 'TSDisable rainbow'
            vim.cmd 'TSEnable rainbow'
          end,
        })
      end,
    },
    {
      'Wansmer/treesj',
      opts = {
        use_default_keymaps = false,
      },
    },
  },
  build = ':TSUpdate',
  opts = {
    -- add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      'c',
      'cpp',
      'lua',
      'rust',
      'tsx',
      'typescript',
      'javascript',
      'vimdoc',
      'vim',
    },

    -- autoinstall languages that are not installed. defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<m-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- you can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']m'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[m'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  },
  ---@param opts TSConfig
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}
