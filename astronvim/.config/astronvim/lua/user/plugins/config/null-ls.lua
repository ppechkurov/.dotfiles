return function(null_ls_config)
	-- config variable is the default configuration table for the setup functino call
	local null_ls = require("null-ls")
	-- Check supported formatters and linters
	-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
	-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
	null_ls_config.sources = {
		-- Set a formatter
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.prettier.with({
			filetypes = { "st" },
		}),
	}
	-- set up null-ls's on_attach function
	-- NOTE: You can remove this on attach function to disable format on save
	null_ls_config.on_attach = function(client)
		if client.server_capabilities.document_formatting then
			vim.api.nvim_create_autocmd("BufWritePre", {
				desc = "Auto format before save",
				pattern = "<buffer>",
				callback = vim.lsp.buf.format,
			})
		end
	end
	return null_ls_config -- return final config table to use in require("null-ls").setup(config)
end
