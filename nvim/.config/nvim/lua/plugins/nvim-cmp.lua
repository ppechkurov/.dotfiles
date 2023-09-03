return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    'hrsh7th/cmp-nvim-lsp', -- adds LSP completion capabilities
    'hrsh7th/cmp-cmdline', -- command line Completion

    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',
  },
  opts = function()
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    require('luasnip.loaders.from_vscode').lazy_load()
    luasnip.config.setup {}

    return {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-f>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = cmp.config.sources {
        { name = 'nvim_lsp', priority = 8 },
        { name = 'luasnip', priority = 7 },
        { name = 'path', priority = 7 },
        { name = 'buffer', priority = 7 }, -- first for locality sorting?
        {
          name = 'spell',
          keyword_length = 3,
          priority = 5,
          keyword_pattern = [[\w\+]],
        },
        {
          name = 'dictionary',
          keyword_length = 3,
          priority = 5,
          keyword_pattern = [[\w\+]],
        }, -- from uga-rosa/cmp-dictionary plug
        { name = 'nvim_lua', priority = 5 },
        { name = 'calc', priority = 3 },
      },
      formatting = {
        format = function(_, item)
          local icons = require('core.icons').kinds
          if icons[item.kind] then
            item.kind = icons[item.kind] .. item.kind
          end
          return item
        end,
      },
    }
  end,
}
