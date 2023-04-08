-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
	-- first key is the mode
	n = {
		-- second key is the lefthand side of the map
		-- mappings seen under group name "Buffer"
		["<S-h>"] = { "<cmd>bprevious<cr>", desc = "Previous Buffer" },
		["<S-l>"] = { "<cmd>bnext<cr>", desc = "Next Buffer" },
		["<leader>o"] = { "<cmd>only<cr>", desc = "Only display current window" },
		["<leader>q"] = { "<C-w>q", desc = "Quit current window" },
		["Q"] = false, -- get rid of this pesky :ex mode see - https://github.com/DJMcMayhem/dotFiles/blob/2f91270f2e88ddd9a916c8d81702dcb2e043f5c7/.vimrc#L283
	},
	t = {
		-- setting a mapping to false will disable it
		-- ["<esc>"] = false,
	},
	-- mappings for arrow keys with ctrl
	i = {
		-- ["<C-h>"] = { "<Left>", desc = "Go Left" },
		-- ["<C-l>"] = { "<Right>", desc = "Go Right" },
		-- ["<C-k>"] = { "<C-o>gk", desc = "Go Up" },
		-- ["<C-j>"] = { "<C-o>gj", desc = "Go Down" },
	},
}
