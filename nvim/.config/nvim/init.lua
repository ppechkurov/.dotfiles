require('config.launch')
require('config.options')
require('config.keymaps')
require('config.autocmds')

spec('plugins.treesitter')

spec('plugins.lsp.cmp')
spec('plugins.lsp.lspconfig')
spec('plugins.lsp.mason')
spec('plugins.lsp.schemastore')

spec('plugins.formatters.conform')

spec('plugins.telescope')
spec('plugins.comment')
spec('plugins.whichkey')

spec('plugins.ui.bottom.lualine')
spec('plugins.ui.colorscheme')
spec('plugins.ui.devicons')
spec('plugins.ui.oil')
spec('plugins.ui.tabs.tabby')
spec('plugins.ui.top.breadcrumbs')
spec('plugins.ui.top.navic')
spec('plugins.ui.tree.neotree')
spec('plugins.ui.illuminate')
spec('plugins.autopairs')
spec('plugins.gitsigns')
spec('plugins.indentline')
spec('plugins.mini-indetoscope')
spec('plugins.ui.ufo')

spec('plugins.dressing')
spec('plugins.colorizer')

require('config.lazy')
