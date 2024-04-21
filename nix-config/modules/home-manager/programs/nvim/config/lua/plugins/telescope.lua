return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', lazy = true },
    -- 'nvim-telescope/telescope-ui-select.nvim',
  },
  config = function()
    local wk = require('which-key')
    wk.register({
      -- quick find
      ['<leader><space>'] = { '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', 'Buffers' },
      -- ['<Tab>'] = { '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', 'Buffers' },
      ['<leader>/'] = { '<cmd>Telescope live_grep<cr>', 'Grep' },
      ['<leader>:'] = { '<cmd>Telescope command_history<cr>', 'Command History' },
      -- files
      ['<leader>ff'] = { '<cmd>Telescope find_files<cr>', '[f]iles' },
      ['<leader>fF'] = { '<cmd>Telescope git_files<cr>', '[F]iles(.git)' },
      ['<leader>fg'] = { '<cmd>Telescope live_grep<cr>', '[g]rep' },
      ['<leader>f.'] = { '<cmd>Telescope oldfiles<cr>', '[.]oldfiles' },
      ['<leader>fr'] = { '<cmd>Telescope resume<cr>', '[r]esume' },
      -- diagnostics
      ['<leader>fd'] = { '<cmd>Telescope diagnostics bufnr=0<cr>', '[d]iagnostics(buffer)' },
      ['<leader>fD'] = { '<cmd>Telescope diagnostics<cr>', '[D]iagnostics(workspace)' },
      -- misc
      ['<leader>fp'] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", '[p]rojects' },
      ['<leader>fh'] = { '<cmd>Telescope help_tags<cr>', '[h]elp' },
      ['<leader>fk'] = { '<cmd>Telescope keymaps<cr>', '[k]eymaps' },
      -- git
      ['<leader>gb'] = { '<cmd>Telescope git_branches<cr>', 'Git Branch' },
      ['<leader>gc'] = { '<cmd>Telescope git_commits<cr>', 'Git Commits' },
      ['<leader>gf'] = { '<cmd>Telescope git_commits<cr>', 'Git Files' },
    })

    local icons = require('config.icons')
    local actions = require('telescope.actions')

    local find_files_with_hidden = function()
      local action_state = require('telescope.actions.state')
      local line = action_state.get_current_line()
      require('telescope.builtin').find_files({ hidden = true, default_text = line })
    end

    local telescope = require('telescope')

    telescope.setup({
      defaults = {
        prompt_prefix = ' _: ',
        selection_caret = ' ',
        -- prompt_prefix = icons.ui.Telescope .. ' ',
        -- selection_caret = icons.ui.Forward .. ' ',
        entry_prefix = '   ',
        initial_mode = 'insert',
        selection_strategy = 'reset',
        path_display = { 'smart' },
        color_devicons = true,
        vimgrep_arguments = {
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
          '--smart-case',
          '--hidden',
          '--glob=!.git/',
        },

        mappings = {
          i = {
            ['<C-n>'] = actions.cycle_history_next,
            ['<C-p>'] = actions.cycle_history_prev,

            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,

            ['<C-h>'] = find_files_with_hidden,
          },
          n = {
            ['<esc>'] = actions.close,
            ['j'] = actions.move_selection_next,
            ['k'] = actions.move_selection_previous,
            ['q'] = actions.close,
          },
        },
      },
      pickers = {
        live_grep = {
          theme = 'dropdown',
        },

        grep_string = {
          theme = 'dropdown',
        },

        find_files = {
          -- layout_config = { height = 0.85, width = 0.85 },
          -- theme = 'dropdown',
          -- hidden = true,
          -- previewer = false,
        },

        buffers = {
          theme = 'dropdown',
          previewer = false,
          initial_mode = 'normal',
          mappings = {
            i = {
              ['<C-d>'] = actions.delete_buffer,
            },
            n = {
              ['dd'] = actions.delete_buffer,
            },
          },
        },

        planets = {
          show_pluto = true,
          show_moon = true,
        },

        colorscheme = {
          enable_preview = true,
        },

        lsp_references = {
          theme = 'dropdown',
          initial_mode = 'normal',
        },

        lsp_definitions = {
          theme = 'dropdown',
          initial_mode = 'normal',
        },

        lsp_declarations = {
          theme = 'dropdown',
          initial_mode = 'normal',
        },

        lsp_implementations = {
          theme = 'dropdown',
          initial_mode = 'normal',
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
        },
      },
    })
  end,
}
