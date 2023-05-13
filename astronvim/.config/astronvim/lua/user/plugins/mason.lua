return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = { ensure_installed = { "jsonls", "lua_ls", "vtsls" } },
	},
	{
		"jay-babu/mason-null-ls.nvim",
		opts = { ensure_installed = { "stylua", "prettier", "eslint-lsp" } },
	},
}
