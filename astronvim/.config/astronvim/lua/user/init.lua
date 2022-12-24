--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key
local config = {

	-- Configure AstroNvim updates
	updater = {
		remote = "origin", -- remote to use
		channel = "nightly", -- "stable" or "nightly"
		version = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
		branch = "main", -- branch name (NIGHTLY ONLY)
		commit = nil, -- commit hash (NIGHTLY ONLY)
		pin_plugins = nil, -- nil, true, false (nil will pin plugins on stable only)
		skip_prompts = false, -- skip prompts about breaking changes
		show_changelog = true, -- show the changelog after performing an update
		auto_reload = false, -- automatically reload and sync packer after a successful update
		auto_quit = false, -- automatically quit the current session after a successful update
		-- remotes = { -- easily add new remotes to track
		--   ["remote_name"] = "https://remote_url.come/repo.git", -- full remote url
		--   ["remote2"] = "github_user/repo", -- GitHub user/repo shortcut,
		--   ["remote3"] = "github_user", -- GitHub user assume AstroNvim fork
		-- },
	},

	-- Set colorscheme to use
	-- colorscheme = "gruvbox-material",
	-- colorscheme = "gruvbox-baby",
	-- colorscheme = "tokyonight-night",
	-- colorscheme = "tundra",
	-- colorscheme = "kanagawa",
	colorscheme = "darkplus",

	-- Override highlight groups in any theme
	highlights = {
		-- duskfox = { -- a table of overrides/changes to the default
		--   Normal = { bg = "#000000" },
		-- },
		default_theme = function(highlights) -- or a function that returns a new table of colors to set
			local C = require("default_theme.colors")

			highlights.Normal = { fg = C.fg, bg = C.bg }
			return highlights
		end,
	},

	-- set vim options here (vim.<first_key>.<second_key> =  value)
	options = {
		opt = {
			relativenumber = true, -- sets vim.opt.relativenumber
			colorcolumn = "80",
		},
		g = require("user.options"),
	},

	-- Set dashboard header
	header = {
		" █████  ███████ ████████ ██████   ██████",
		"██   ██ ██         ██    ██   ██ ██    ██",
		"███████ ███████    ██    ██████  ██    ██",
		"██   ██      ██    ██    ██   ██ ██    ██",
		"██   ██ ███████    ██    ██   ██  ██████",
		" ",
		"    ███    ██ ██    ██ ██ ███    ███",
		"    ████   ██ ██    ██ ██ ████  ████",
		"    ██ ██  ██ ██    ██ ██ ██ ████ ██",
		"    ██  ██ ██  ██  ██  ██ ██  ██  ██",
		"    ██   ████   ████   ██ ██      ██",
	},

	-- Default theme configuration
	default_theme = {
		-- set the highlight style for diagnostic messages
		diagnostics_style = { italic = true },
		-- Modify the color palette for the default theme
		colors = {
			fg = "#abb2bf",
			bg = "#1e222a",
		},
		-- enable or disable highlighting for extra plugins
		plugins = {
			aerial = true,
			beacon = false,
			bufferline = true,
			dashboard = true,
			highlighturl = true,
			hop = false,
			indent_blankline = true,
			lightspeed = false,
			["neo-tree"] = true,
			notify = true,
			["nvim-tree"] = false,
			["nvim-web-devicons"] = true,
			rainbow = true,
			symbols_outline = false,
			telescope = true,
			vimwiki = false,
			["which-key"] = true,
		},
	},

	-- Diagnostics configuration (for vim.diagnostics.config({...}))
	diagnostics = {
		virtual_text = true,
		underline = true,
	},

	-- Extend LSP configuration
	lsp = {
		-- enable servers that you already have installed without mason
		servers = {
			-- "pyright"
		},
		formatting = {
			-- control auto formatting on save
			format_on_save = {
				enabled = false, -- enable or disable format on save globally
			},
		},
		-- easily add or disable built in mappings added during LSP attaching
		mappings = {
			n = {
				-- ["<leader>lf"] = false -- disable formatting keymap
			},
		},
		-- add to the global LSP on_attach function
		-- on_attach = function(client, bufnr)
		-- end,

		-- override the mason server-registration function
		-- server_registration = function(server, opts)
		--   require("lspconfig")[server].setup(opts)
		-- end,

		-- Add overrides for LSP server settings, the keys are the name of the server
		["server-settings"] = {
			-- example for addings schemas to yamlls
			-- yamlls = { -- override table for require("lspconfig").yamlls.setup({...})
			--   settings = {
			--     yaml = {
			--       schemas = {
			--         ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}",
			--         ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
			--         ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
			--       },
			--     },
			--   },
			-- },
			-- Example disabling formatting for a specific language server
			-- gopls = { -- override table for require("lspconfig").gopls.setup({...})
			--   on_attach = function(client, bufnr)
			--     client.resolved_capabilities.document_formatting = false
			--   end
			-- }
			apex_ls = { -- override table for require("lspconfig").apex_ls.setup({...})
				filetypes = { "st" },
				on_attach = function(client, bufnr)
					require("nvim-treesitter.parsers").filetype_to_parsername.st = "java"
					vim.cmd.TSEnable("highlight")
					vim.cmd.TSEnable("indent")
					vim.cmd.TSEnable("rainbow")
					vim.api.nvim_set_keymap("n", "<leader>lf", ":lua vim.lsp.buf.format({timeout_ms=2000})<CR>", {
						noremap = true,
						desc = "Format Code",
					})
					-- highlight words in apex
					vim.cmd([[
								augroup highlight_current_word
  							au!
  							au CursorHold * :exec 'match Search /\V\<' . expand('<cword>') . '\>/'
								augroup END
					]])
				end,
				apex_enable_semantic_errors = true,
			},
		},
	},

	-- Mapping data with "desc" stored directly by vim.keymap.set().
	--
	-- Please use this mappings table to set keyboard mapping since this is the
	-- lower level configuration and more robust one. (which-key will
	-- automatically pick-up stored data by this setting.)
	mappings = {
		-- first key is the mode
		n = {
			-- second key is the lefthand side of the map
			-- mappings seen under group name "Buffer"
			["<leader>bb"] = { "<cmd>tabnew<cr>", desc = "New tab" },
			["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>", desc = "Pick to close" },
			["<leader>bj"] = { "<cmd>BufferLinePick<cr>", desc = "Pick to jump" },
			["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs" },
			["<esc>"] = { "<cmd>nohlsearch<cr>", desc = "noh on esc" },
			-- quick save
			-- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
		},
		t = {
			-- setting a mapping to false will disable it
			-- ["<esc>"] = false,
		},
	},

	-- Configure plugins
	plugins = {
		init = require("user.plugins"),

		-- All other entries override the require("<key>").setup({...}) call for default plugins
		["cmp"] = require("user.plugins.config.cmp"),
		["feline"] = require("user.plugins.config.feline"),
		["session_manager"] = require("user.plugins.config.session_manager"),
		["neo-tree"] = require("user.plugins.config.neo-tree"),
		["null-ls"] = require("user.plugins.config.null-ls"),

		treesitter = { -- overrides `require("treesitter").setup(...)`
			ensure_installed = { "lua", "typescript", "javascript" },
		},

		-- use mason-lspconfig to configure LSP installations
		["mason-lspconfig"] = { -- overrides `require("mason-lspconfig").setup(...)`
			ensure_installed = { "sumneko_lua", "tsserver", "apex_ls" },
		},
		-- use mason-tool-installer to configure DAP/Formatters/Linter installation
		["mason-tool-installer"] = { -- overrides `require("mason-tool-installer").setup(...)`
			ensure_installed = { "prettier", "stylua", "eslint" },
		},
		packer = { -- overrides `require("packer").setup(...)`
			compile_path = vim.fn.stdpath("data") .. "/packer_compiled.lua",
		},
	},

	-- LuaSnip Options
	luasnip = {
		-- Add paths for including more VS Code style snippets in luasnip
		vscode_snippet_paths = {},
		-- Extend filetypes
		filetype_extend = {
			javascript = { "javascriptreact" },
		},
	},

	-- CMP Source Priorities
	-- modify here the priorities of default cmp sources
	-- higher value == higher priority
	-- The value can also be set to a boolean for disabling default sources:
	-- false == disabled
	-- true == 1000
	cmp = {
		source_priority = {
			nvim_lsp = 1000,
			luasnip = 750,
			buffer = 500,
			path = 250,
		},
	},

	-- Modify which-key registration (Use this with mappings table in the above.)
	["which-key"] = {
		-- Add bindings which show up as group name
		register_mappings = {
			-- first key is the mode, n == normal mode
			n = {
				-- second key is the prefix, <leader> prefixes
				["<leader>"] = {
					-- third key is the key to bring up next level and its displayed
					-- group name in which-key top level menu
					["b"] = { name = "Buffer" },
				},
			},
		},
	},

	-- This function is run last and is a good place to configuring
	-- augroups/autocommands and custom filetypes also this just pure lua so
	-- anything that doesn't fit in the normal config locations above can go here
	polish = function()
		-- Set key binding
		-- Set autocommands
		require("user.autocommands")
		-- Set up custom filetypes
		-- vim.filetype.add {
		--   extension = {
		--     foo = "fooscript",
		--   },
		--   filename = {
		--     ["Foofile"] = "fooscript",
		--   },
		--   pattern = {
		--     ["~/%.config/foo/.*"] = "fooscript",
		--   },
		-- }
	end,
}

return config
