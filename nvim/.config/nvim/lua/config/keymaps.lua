-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set(
  "n",
  "<leader>cll",
  "yiwoconsole.log('<c-r>\":', <c-r>\");<esc>_",
  { silent = true, desc = "Console: Log variable under cursor" }
)

vim.keymap.set("n", "n", "nzz", { silent = true, desc = "Center screen after n" })
vim.keymap.set("n", "N", "Nzz", { silent = true, desc = "Center screen after N" })
