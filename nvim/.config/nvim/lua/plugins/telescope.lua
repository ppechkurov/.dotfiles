return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', lazy = true },
  },
  config = function()
    local wk = require('which-key')
    wk.register({
      -- quick find
      ['<leader><space>'] = { '<cmd>Telescope buffers previewer=false<cr>', 'Buffers' },
      ['<leader>/'] = { '<cmd>Telescope live_grep<cr>', 'Grep' },
      ['<leader>:'] = { '<cmd>Telescope command_history<cr>', 'Command History' },
      -- files
      ['<leader>ff'] = { '<cmd>Telescope find_files<cr>', 'Find files' },
      ['<leader>fg'] = { '<cmd>Telescope live_grep<cr>', 'Find Grep' },
      ['<leader>fo'] = { '<cmd>Telescope oldfiles<cr>', 'Old Files' },
      -- misc
      ['<leader>fp'] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", 'Projects' },
      ['<leader>fr'] = { '<cmd>Telescope resume<cr>', 'Resume' },
      ['<leader>fh'] = { '<cmd>Telescope help_tags<cr>', 'Help' },
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

    local Layout = require('nui.layout')
    local Popup = require('nui.popup')

    local telescope = require('telescope')
    local TSLayout = require('telescope.pickers.layout')

    local function make_popup(options)
      local popup = Popup(options)
      function popup.border:change_title(title)
        popup.border.set_text(popup.border, 'top', title)
      end
      return TSLayout.Window(popup)
    end

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
          theme = 'dropdown',
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
