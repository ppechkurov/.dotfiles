local wk = require("which-key")

wk.register({
	a = { "harpoon" },
	c = {
		name = "close",
		c = { "<cmd>bdelete<cr>", "current" },
	},
	d = { "delete in no register" },
	e = { "<cmd>Neotree toggle<cr>", "explorer" },
	f = {
		name = "find",
		b = { "<cmd>Telescope buffers<cr>", "buffer" },
		f = { "<cmd>Telescope find_files<cr>", "file" },
		g = { "<cmd>Telescope git_files<cr>", "git" },
		w = { "<cmd>Telescope live_grep<cr>", "word" },
	},
	p = { "paste previous" },
	l = {
		name = "LSP",
		a = { "action" },
		f = { "format" },
		r = { "rename" },
	},
	x = { "chmod +x" },
	y = { "yank in the system clipboard" },
}, { prefix = "<leader>" })
