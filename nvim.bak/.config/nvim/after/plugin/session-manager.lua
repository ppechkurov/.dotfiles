require("session_manager").setup({
	autoload_mode = require("session_manager.config").AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
	autosave_last_session = true, -- Automatically save last session on exit and on session switch.
	autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
	autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
	autosave_ignore_buftypes = { "neo-tree" }, -- All buffers of these bufer types will be closed before the session is saved.
})
