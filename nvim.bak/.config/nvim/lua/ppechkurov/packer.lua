-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Telescope
	use({ "nvim-telescope/telescope.nvim", tag = "0.1.0", requires = { { "nvim-lua/plenary.nvim" } } })

	-- Rose Pine theme
	use({
		"rose-pine/neovim",
		as = "rose-pine",
		config = function()
			vim.cmd("colorscheme rose-pine")
		end,
	})

	-- TreeSitter
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("p00f/nvim-ts-rainbow")
	use("windwp/nvim-ts-autotag")

    -- Harpoon for files
	use("ThePrimeagen/harpoon")

	-- CMP icons
	use("onsails/lspkind.nvim")

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- Commenting
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

    -- Lines between parenthasies
	use("lukas-reineke/indent-blankline.nvim")

    -- Highlight on hover
	use("RRethy/vim-illuminate")

	-- Status Line
	use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons", opt = true } })

	use("nvim-tree/nvim-web-devicons")

    -- Scorllbar
	use("petertriho/nvim-scrollbar")

    -- Buffers
	use({ "akinsho/bufferline.nvim", tag = "v3.*", requires = "nvim-tree/nvim-web-devicons" })

	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})

    -- Neo Tree
	-- Unless you are still migrating, remove the deprecated commands from v1.x
	vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	})

    -- Leap navigation
	use({
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()
		end,
	})

	use({ "Shatur/neovim-session-manager" })

	use({ "f-person/git-blame.nvim" })

	use({ "folke/which-key.nvim" })

    -- Format only modifications
	use({ "joechrisellis/lsp-format-modifications.nvim" })

    -- Json schemas
	use("b0o/schemastore.nvim")

    -- Git shit
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup()
		end,
	})

    -- Formatting
	use({ "jose-elias-alvarez/null-ls.nvim", "jayp0521/mason-null-ls.nvim" })
end)
