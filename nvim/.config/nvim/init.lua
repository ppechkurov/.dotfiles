require('config.launch')
require('config.options')
require('config.keymaps')
require('config.autocmds')

spec('config.colorscheme')

spec('plugins.devicons')
spec('plugins.treesitter')
spec('plugins.mason')
spec('plugins.schemastore')
spec('plugins.lspconfig')
spec('plugins.cmp')
spec('plugins.telescope')
spec('plugins.comment')

spec('plugins.conform')

require('config.lazy')
