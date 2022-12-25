require("mason").setup()

local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.prettier.with({ filetypes = { "st" } }),
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.diagnostics.eslint,
	},

	on_attach = function(client, bufnr)
		local lsp_format_modifications = require("lsp-format-modifications")
		lsp_format_modifications.attach(client, bufnr, { format_on_save = false })
	end,
})

require("mason-null-ls").setup({
	ensure_installed = nil,
	automatic_installation = true,
	automatic_setup = false,
})
