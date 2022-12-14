local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.ensure_installed({
	"tsserver",
	"eslint",
	"sumneko_lua",
	"apex_ls",
	"jsonls",
})

-- Fix Undefined global 'vim'
lsp.configure("sumneko_lua", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

lsp.configure("tsserver", {
	on_attach = function(client, bufnr)
		client.server_capabilities.documentFormattingProvider = false
	end,
})

lsp.configure("apex_ls", {
	filetypes = { "st" },
	on_attach = function(client, bufnr)
		require("nvim-treesitter.parsers").filetype_to_parsername.st = "java"
		vim.cmd.TSEnable("highlight")
		vim.cmd.TSEnable("indent")
		vim.cmd.TSEnable("rainbow")

		vim.cmd([[
				augroup highlight_current_word
  				au!
  				au CursorHold * :exec 'match Search /\V\<' . expand('<cword>') . '\>/'
				augroup END
			]])
	end,
	apex_enable_semantic_errors = true,
})

lsp.configure("jsonls", {
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

lsp.setup_nvim_cmp(require("ppechkurov.cmp"))

lsp.set_preferences({
	suggest_lsp_servers = false,
})

lsp.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }
	if client.name ~= "apex_ls" then
		require("illuminate").on_attach(client)
	end

	if client.server_capabilities.documentRangeFormattingProvider then
		vim.keymap.set("v", "gma", vim.lsp.formatexpr, opts)
	end

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
	vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
	vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
})
