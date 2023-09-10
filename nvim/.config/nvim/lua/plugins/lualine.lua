return {
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  event = 'VeryLazy',
  opts = function()
    local branch = {
      'branch',
      icon = '',
      padding = { left = 1, right = 1 },
      color = { fg = '#468a58' },
    }

    local diff = {
      'diff',
      colored = true,
      color = {
        added = 'DiffAdd',
        modified = 'DiffChange',
        removed = 'DiffDelete',
      },
      symbols = { added = ' ', modified = ' ', removed = ' ' },
      padding = { left = 1, right = 1 },
    }

    local result = vim.fn.system 'git rev-parse --is-inside-work-tree'
    local gitcheck = function()
      if result:match 'true' then
        return ''
      else
        return ' 󱓌 '
      end
    end

    local location = {
      'location',
      padding = 1,
    }

    local modes = {
      function()
        -- local animated = {
        -- "  ",
        -- "  ",
        -- " 󱠡 ",
        -- }
        -- return animated[os.date("%S") % #animated + 1]
        local animated = '  '
        return animated
      end,
      separator = { left = '', right = '' },
    }

    local lsp_progess = function()
      local msg
      msg = msg or '✖'
      local buf_clients = vim.lsp.get_active_clients()
      if next(buf_clients) == nil then
        if type(msg) == 'boolean' or #msg == 0 then
          return 'NO LSP'
        end
        return msg
      end
      local buf_ft = vim.bo.filetype
      local buf_client_names = {}
      local null_ls = require 'null-ls'
      local alternative_methods = {
        null_ls.methods.DIAGNOSTICS,
        null_ls.methods.DIAGNOSTICS_ON_OPEN,
        null_ls.methods.DIAGNOSTICS_ON_SAVE,
      }

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= 'null-ls' and client.name ~= 'copilot' then
          table.insert(buf_client_names, client.name)
        end
      end

      local list_registered_providers_names = function(filetype)
        local s = require 'null-ls.sources'
        local available_sources = s.get_available(filetype)
        local registered = {}
        for _, source in ipairs(available_sources) do
          for method in pairs(source.methods) do
            registered[method] = registered[method] or {}
            table.insert(registered[method], source.name)
          end
        end
        return registered
      end

      local list_registered = function(filetype)
        local registered_providers = list_registered_providers_names(filetype)
        local providers_for_methods = vim.tbl_flatten(vim.tbl_map(function(m)
          return registered_providers[m] or {}
        end, alternative_methods))
        return providers_for_methods
      end

      local formatters_list_registered = function(filetype)
        local registered_providers = list_registered_providers_names(filetype)
        return registered_providers[null_ls.methods.FORMATTING] or {}
      end

      -- formatters
      local supported_formatters = formatters_list_registered(buf_ft)
      vim.list_extend(buf_client_names, supported_formatters)

      -- linters
      local supported_linters = list_registered(buf_ft)
      vim.list_extend(buf_client_names, supported_linters)
      local unique_client_names = vim.fn.uniq(buf_client_names)

      local language_servers = table.concat(unique_client_names, ', ')

      return language_servers
    end

    return {
      options = {
        globalstatus = true,
        icons_enabled = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { modes },
        lualine_b = {
          {
            'filetype',
            icon_only = true,
            colored = true,
            padding = { left = 2 },
          },
          {
            'filename',
            padding = 1,
            separator = { left = '', right = '' },
            file_status = true,
            newfile_status = true,
            path = 5,
            symbols = {
              modified = '',
              readonly = '',
              unnamed = '',
              newfile = '',
            },
          },
        },
        lualine_c = {
          { gitcheck },
          branch,
          diff,
          {
            function()
              return ' '
            end,
            separator = { left = '', right = '' },
            color = { fg = '#000000', bg = '#a3a3a3' },
          },
        },
        lualine_x = {
          {
            function()
              return ' '
            end,
            separator = { left = '', right = '' },
            color = { fg = '#000000', bg = '#faac64' },
          },
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = { error = ' ', warn = ' ', hint = ' ', info = ' ' },
            colored = true,
            padding = { left = 1, right = 1 },
            always_visible = false,
            update_in_insert = true,
          },
          { lsp_progess },
          {
            function()
              return ''
            end,
            separator = { left = '', right = '' },
          },
          location,
        },
        lualine_y = {},
        lualine_z = {},
      },
    }
  end,
}
