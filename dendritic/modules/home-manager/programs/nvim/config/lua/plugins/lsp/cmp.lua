local M = {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    {
      'hrsh7th/cmp-nvim-lsp',
      event = 'InsertEnter',
    },
    {
      'hrsh7th/cmp-emoji',
      event = 'InsertEnter',
    },
    {
      'hrsh7th/cmp-buffer',
      event = 'InsertEnter',
    },
    {
      'hrsh7th/cmp-path',
      event = 'InsertEnter',
    },
    {
      'hrsh7th/cmp-cmdline',
      event = 'InsertEnter',
    },
    {
      'saadparwaiz1/cmp_luasnip',
      event = 'InsertEnter',
    },
    {
      'L3MON4D3/LuaSnip',
      event = 'InsertEnter',
      dependencies = {
        'rafamadriz/friendly-snippets',
      },
    },
    {
      'hrsh7th/cmp-nvim-lua',
    },
  },
}

function M.config()
  local cmp = require('cmp')
  local compare = cmp.config.compare

  local luasnip = require('luasnip')
  require('luasnip/loaders/from_vscode').lazy_load()

  local icons = require('config.icons')

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    completion = {
      autocomplete = false,
      -- completeopt = 'menu,menuone',
    },
    mapping = cmp.mapping.preset.insert({
      -- ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      -- ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete({}), { 'i', 'c' }),
      ['<C-d>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
      -- ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
      ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
      ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
      ['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      -- ['<C-Space>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, {
        'i',
        's',
      }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        'i',
        's',
      }),
    }),
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      expandable_indicator = true,
      format = function(entry, vim_item)
        vim_item.kind = icons.kind[vim_item.kind]
        vim_item.menu = ({
          nvim_lsp = '',
          nvim_lua = '',
          luasnip = '',
          buffer = '',
          path = '',
          emoji = '',
        })[entry.source.name]

        if entry.source.name == 'emoji' then
          vim_item.kind = icons.misc.Smiley
          vim_item.kind_hl_group = 'CmpItemKindEmoji'
        end

        if entry.source.name == 'cmp_tabnine' then
          vim_item.kind = icons.misc.Robot
          vim_item.kind_hl_group = 'CmpItemKindTabnine'
        end

        return vim_item
      end,
    },
    sources = {
      { name = 'nvim_lsp', priority = 1000 },
      { name = 'luasnip' },
      { name = 'nvim_lua' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'calc' },
      { name = 'emoji' },
    },
    sorting = {
      priority_weight = 1.0,
      comparators = {
        compare.sort_text,
        compare.score,
        compare.offset,
        compare.exact,
        compare.recently_used,
        compare.locality,
        compare.kind,
        compare.length,
      },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    window = {
      completion = {
        border = 'none',
        scrollbar = true,
      },
      documentation = {
        border = 'none',
      },
    },
    experimental = {
      ghost_text = false,
    },
  })
end

return M
