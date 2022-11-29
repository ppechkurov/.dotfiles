return {
	-- You can disable default plugins as follows:
	-- ["goolord/alpha-nvim"] = { disable = true },
	["declancm/cinnamon.nvim"] = { disable = true },

	-- You can also add new plugins here as well:
	-- Add plugins, the packer syntax without the "use"
	{ "f-person/git-blame.nvim" },
	{ "sainnhe/gruvbox-material" },

	-- { "luisiacc/gruvbox-baby" },

	-- Lsp signatures for functions
	{
		"ray-x/lsp_signature.nvim",
		config = function()
			require("lsp_signature").setup()
		end,
	},

	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()
		end,
	},
	{
		"petertriho/nvim-scrollbar",
		config = function()
			require("scrollbar").setup()
		end,
	},
	{ "folke/tokyonight.nvim" },
}
