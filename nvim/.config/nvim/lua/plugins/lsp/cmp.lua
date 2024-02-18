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

  local luasnip = require('luasnip')
  require('luasnip/loaders/from_vscode').lazy_load()

  local check_backspace = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s')
  end

  local icons = require('config.icons')

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    mapping = cmp.mapping.preset.insert({
      -- ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      -- ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      -- ['<C-Space>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
      -- ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
      ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
      ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
      ['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif check_backspace() then
          fallback()
          -- require("neotab").tabout()
        else
          fallback()
          -- require("neotab").tabout()
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
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'nvim_lua' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'calc' },
      { name = 'emoji' },
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
--return {
--  -- Use <tab> for completion and snippets (supertab)
--  -- first: disable default <tab> and <s-tab> behavior in LuaSnip
--  {
--    "L3MON4D3/LuaSnip",
--    keys = function()
--      return {}
--    end,
--  },
--  -- then: setup supertab in cmp
--  {
--    "hrsh7th/nvim-cmp",
--    dependencies = {
--      "hrsh7th/cmp-emoji",
--    },
--    ---@param opts cmp.ConfigSchema
--    opts = function(_, opts)
--      local has_words_before = function()
--        unpack = unpack or table.unpack
--        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
--      end
--
--      local luasnip = require("luasnip")
--      local cmp = require("cmp")
--
--      -- don't select first item. to be able to autocmp by pressing tab
--      ---@diagnostic disable-next-line: missing-fields
--      opts.completion = {
--        completeopt = "menu,menuone,noinsert,noselect",
--      }
--
--      opts.mapping = vim.tbl_extend("force", opts.mapping, {
--        ["<C-f>"] = cmp.mapping.scroll_docs(-4),
--
--        ["<C-d>"] = cmp.mapping.scroll_docs(4),
--
--        ["<C-Space>"] = cmp.mapping.complete({}),
--
--        ["<CR>"] = cmp.mapping.confirm({
--          behavior = cmp.ConfirmBehavior.Replace,
--          select = true,
--        }),
--
--        ["<Tab>"] = cmp.mapping(function(fallback)
--          if cmp.visible() then
--            cmp.select_next_item()
--          elseif luasnip.expand_or_locally_jumpable() then
--            luasnip.expand_or_jump()
--          -- elseif has_words_before() then
--          --   cmp.complete()
--          else
--            fallback()
--          end
--        end, { "i", "s" }),
--
--        ["<S-Tab>"] = cmp.mapping(function(fallback)
--          if cmp.visible() then
--            cmp.select_prev_item()
--          elseif luasnip.locally_jumpable(-1) then
--            luasnip.jump(-1)
--          else
--            fallback()
--          end
--        end, { "i", "s" }),
--
--        ["<C-k>"] = cmp.mapping({
--          i = function()
--            if cmp.visible() then
--              cmp.abort()
--            else
--              cmp.complete()
--            end
--          end,
--          c = function()
--            if cmp.visible() then
--              cmp.close()
--            else
--              cmp.complete()
--            end
--          end,
--        }),
--      })
--      -- opts.mapping = vim.tbl_extend("force", opts.mapping, {
--      --   ["<Tab>"] = cmp.mapping(function(fallback)
--      --     if cmp.visible() then
--      --       cmp.select_next_item()
--      --       -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
--      --       -- this way you will only jump inside the snippet region
--      --     elseif luasnip.expand_or_jumpable() then
--      --       luasnip.expand_or_jump()
--      --     elseif has_words_before() then
--      --       cmp.complete()
--      --     else
--      --       fallback()
--      --     end
--      --   end, { "i", "s" }),
--      --   ["<S-Tab>"] = cmp.mapping(function(fallback)
--      --     if cmp.visible() then
--      --       cmp.select_prev_item()
--      --     elseif luasnip.jumpable(-1) then
--      --       luasnip.jump(-1)
--      --     else
--      --       fallback()
--      --     end
--      --   end, { "i", "s" }),
--      -- })
--    end,
--  },
--}
