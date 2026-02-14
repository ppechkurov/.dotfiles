return {
  'nanozuki/tabby.nvim',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local theme = {
      fill = 'TabLineFill',
      head = 'TabLine',
      current_tab = 'TabLineSel',
      tab = 'TabLine',
      win = 'TabLine',
      tail = 'TabLine',
    }

    require('tabby').setup({
      line = function(line)
        return {
          {
            { '  ', hl = theme.head },
            line.sep('', theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.tab

            -- remove count of wins in tab with [n+] included in tab.name()
            local name = tab.name()
            local index = string.find(name, '%[%d')
            local tab_name = index and string.sub(name, 1, index - 1) or name

            return {
              line.sep('', hl, theme.fill),
              tab.is_current() and '' or '',
              tab.number(),
              tab_name,
              line.sep('', hl, theme.fill),
              hl = hl,
              margin = ' ',
            }
          end),
          line.spacer(),
          {
            line.sep('', theme.tail, theme.fill),
            { '  ', hl = theme.tail },
          },
          hl = theme.fill,
        }
      end,
      option = {
        buf_name = {
          mode = 'tail',
        },
      },
    })
  end,
}
