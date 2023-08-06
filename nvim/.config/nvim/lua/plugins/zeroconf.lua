return {
	'Exafunction/codeium.vim',
	-- Git related plugins
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',

	-- Detect tabstop and shiftwidth automatically
	'tpope/vim-sleuth',

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', opts = {} },

	-- buffer remove
	{
		'echasnovski/mini.bufremove',
		-- stylua: ignore
		keys = {
			{ "<leader>c", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
			{ "<leader>C", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
		},
	},

	-- auto pairs
	{
		'echasnovski/mini.pairs',
		event = 'VeryLazy',
		opts = {},
	},
}
