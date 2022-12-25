require("mason").setup()

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.prettierd.with({ filetypes = { "st" } }),
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.eslint,
	},
})

require("mason-null-ls").setup({
	ensure_installed = nil,
	automatic_installation = true,
	automatic_setup = false,
})
