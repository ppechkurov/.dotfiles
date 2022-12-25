vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlighting text on yank",
	command = "silent! lua vim.highlight.on_yank({higroup = 'Search', timeout = 200})",
	group = "YankHighlight",
})
