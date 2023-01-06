local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)

-- navigate to file with number
vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end)
