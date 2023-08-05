return {
	-- Adds git related signs to the gutter, as well as utilities for managing changes
	'lewis6991/gitsigns.nvim',
	opts = {
		-- See `:help gitsigns.txt`
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "▎" },
			topdelete = { text = "▎" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},
		on_attach = function(bufnr)
			local signs = require 'gitsigns'

			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
			end

			map('n', '<leader>gp', signs.prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
			map('n', '<leader>gn', signs.next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
			map('n', '<leader>ph', signs.preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
			map("n", "<leader>ghb", function() signs.blame_line({ full = true }) end, "Blame Line")
		end,
	},
}
--       map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
--       map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
--       map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
--       map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
--       map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
--       map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
--       map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
--       map("n", "<leader>ghd", gs.diffthis, "Diff This")
--       map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
--       map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
