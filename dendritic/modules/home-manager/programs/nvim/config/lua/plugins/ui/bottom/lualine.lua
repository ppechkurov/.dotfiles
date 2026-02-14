local function foreground(name)
  ---@type {foreground?:number}?
  ---@diagnostic disable-next-line: deprecated
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  ---@diagnostic disable-next-line: undefined-field
  local fg = hl and (hl.fg or hl.foreground)
  return fg and { fg = string.format('#%06x', fg) } or nil
end

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = ' '
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = function()
    -- PERF: we don't need this lualine require madness 🤷
    local lualine_require = require('lualine_require')
    lualine_require.require = require

    local icons = require('config.icons')

    vim.o.laststatus = vim.g.lualine_laststatus

    return {
      options = {
        -- theme = require('neofusion.lualine'),
        theme = 'auto',
        globalstatus = vim.o.laststatus == 3,
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },

        disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'starter' } },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },

        lualine_c = {
          {
            'diagnostics',
            symbols = {
              error = icons.diagnostics.Error .. ' ',
              warn = icons.diagnostics.Warning .. ' ',
              info = icons.diagnostics.Information .. ' ',
              hint = icons.diagnostics.Hint .. ' ',
            },
          },
          { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
          {
            'filename',
            path = 0,
            padding = { left = 0, right = 1 },
            symbols = { unnamed = '', readonly = icons.misc.Lock, modified = icons.git.FileUnstaged },
          },
        },
        lualine_x = {
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = foreground("Debug"),
            },
          {
            require('lazy.status').updates,
            cond = require('lazy.status').has_updates,
            color = foreground('Special'),
          },
          -- the bellow commands add macro recording indicatior and key presses
          -- stylua: ignore
          {
            function() return require('noice').api.status.command.get() end,
            cond = function() return package.loaded['noice'] and require('noice').api.status.command.has() end,
            color = { fg = '#ff9e64' },
          },
          -- stylua: ignore
          {
            function() return require("noice").api.status.mode.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            color = { fg = '#ff9e64' },
          },
          {
            'diff',
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { 'location', padding = { left = 1, right = 1 } },
        },
        lualine_z = {
          function()
            return ' ' .. os.date('%R')
          end,
        },
      },
      extensions = { 'neo-tree', 'lazy' },
    }
  end,
}
