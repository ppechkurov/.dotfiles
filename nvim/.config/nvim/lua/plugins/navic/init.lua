-- lsp symbol navigation for lualine. This shows where
-- in the code structure you are - within functions, classes,
-- etc - in the statusline.
return {
	"SmiteshP/nvim-navic",
	lazy = true,
	init = function()
		vim.g.navic_silence = true
	end,
	opts = function()
		return {
			separator = " ",
			highlight = true,
			depth_limit = 5,
			icons = require("config.icons").kinds
		}
	end,
}
