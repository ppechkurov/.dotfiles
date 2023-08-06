return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      local telescope = require 'telescope'

      telescope.setup {
        defaults = {
          mappings = { i = { ['<C-u>'] = false, ['<C-d>'] = false } },
        },
        extensions = {
          file_browser = {
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = true,
            mappings = {
              ['i'] = {
                -- your custom insert mode mappings
              },
              ['n'] = {
                -- your custom normal mode mappings
              },
            },
          },
        },
      }

      -- Enable telescope fzf native, if installed
      pcall(telescope.load_extension, 'fzf')
      pcall(telescope.load_extension, 'file_browser')

      -- [[ Keymaps ]]
      -- See `:help telescope.builtin`
      local nmap = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { desc = desc })
      end
      local builtin = require 'telescope.builtin'

      nmap('<leader>?', builtin.oldfiles, '[?] Find recently opened files')
      nmap('<leader><space>', builtin.buffers, '[ ] Find existing buffers')
      nmap('<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, '[/] Fuzzily search in current buffer')

      nmap('<leader>gf', builtin.git_files, 'Search [G]it [F]iles')
      nmap('<leader>sf', builtin.find_files, '[S]earch [F]iles')
      nmap('<leader>sh', builtin.help_tags, '[S]earch [H]elp')
      nmap('<leader>sw', builtin.grep_string, '[S]earch current [W]ord')
      nmap('<leader>sg', builtin.live_grep, '[S]earch by [G]rep')
      nmap('<leader>sd', builtin.diagnostics, '[S]earch [D]iagnostics')

      nmap('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    end,
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    -- NOTE: If you are having trouble with this installation,
    --       refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
}
