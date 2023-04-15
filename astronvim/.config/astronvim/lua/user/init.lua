for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
	vim.api.nvim_set_hl(0, group, {})
end
return {
	lsp = {
		formatting = {
			format_on_save = true, -- enable or disable automatic formatting on save
			timeout_ms = 3200, -- adjust the timeout_ms variable for formatting
		},
	},
}
