-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local telescope = require('telescope')

telescope.setup {
	defaults = { mappings = { i = { ['<C-u>'] = false, ['<C-d>'] = false, }, } },
}

-- Enable telescope fzf native, if installed
pcall(telescope.load_extension, 'fzf')

-- [[ Keymaps ]]
-- See `:help telescope.builtin`
local nmap = function(keys, func, desc)
	if desc then
		desc = 'lsp: ' .. desc
	end

	vim.keymap.set('n', keys, func, { desc = desc })
end

nmap('<leader>?', require('telescope.builtin').oldfiles, '[?] Find recently opened files')
nmap('<leader><space>', require('telescope.builtin').buffers, '[ ] Find existing buffers')
nmap('<leader>/', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		winblend = 10,
		previewer = false,
	})
end, '[/] Fuzzily search in current buffer')

nmap('<leader>gf', require('telescope.builtin').git_files, 'Search [G]it [F]iles')
nmap('<leader>sf', require('telescope.builtin').find_files, '[S]earch [F]iles')
nmap('<leader>sh', require('telescope.builtin').help_tags, '[S]earch [H]elp')
nmap('<leader>sw', require('telescope.builtin').grep_string, '[S]earch current [W]ord')
nmap('<leader>sg', require('telescope.builtin').live_grep, '[S]earch by [G]rep')
nmap('<leader>sd', require('telescope.builtin').diagnostics, '[S]earch [D]iagnostics')

nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
