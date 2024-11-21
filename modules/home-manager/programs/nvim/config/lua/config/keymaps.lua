vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set(
  'n',
  '<leader>cll',
  'yiwoconsole.log(\'<c-r>":\', <c-r>");<esc>_',
  { silent = true, desc = 'Console: Log variable under cursor' }
)

vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

vim.keymap.set('n', 'n', 'nzz', { silent = true, desc = 'Center screen after n' })
vim.keymap.set('n', 'N', 'Nzz', { silent = true, desc = 'Center screen after N' })

vim.keymap.set('n', '<esc>', ':noh<cr><esc>', { silent = true, desc = 'noh' })

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- Move Lines
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move up' })

-- better indenting
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

vim.keymap.set('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
vim.keymap.set('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
vim.keymap.set('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
vim.keymap.set('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
vim.keymap.set('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
vim.keymap.set('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

---@param types string[] Will return the first node that matches one of these types
---@param node TSNode|nil
---@return TSNode|nil
local function find_node_ancestor(types, node)
  if not node then
    return nil
  end

  if vim.tbl_contains(types, node:type()) then
    return node
  end

  local parent = node:parent()

  return find_node_ancestor(types, parent)
end

---When typing "await" add "async" to the function declaration if the function
---isn't async already.
local function add_async()
  -- This function should be executed when the user types "t" in insert mode,
  -- but "t" is not inserted because it's the trigger.
  vim.api.nvim_feedkeys('t', 'n', true)

  local buffer = vim.fn.bufnr()

  local text_before_cursor = vim.fn.getline('.'):sub(vim.fn.col('.') - 4, vim.fn.col('.') - 1)
  if text_before_cursor ~= 'awai' then
    return
  end

  -- ignore_injections = false makes this snippet work in filetypes where JS is injected
  -- into other languages
  local current_node = vim.treesitter.get_node({ ignore_injections = false })
  local target_node =
    find_node_ancestor({ 'arrow_function', 'function_declaration', 'function', 'method_definition' }, current_node)
  if not target_node then
    return
  end

  if target_node:type() == 'method_definition' then
    target_node = target_node:child(1)
    if not target_node then
      return
    end
  end

  if target_node:type() == 'formal_parameters' then
    target_node = target_node:parent()
    if not target_node then
      return
    end
  end

  local node_text = vim.treesitter.get_node_text(target_node, 0)
  if vim.startswith(node_text, 'async') then
    return
  end

  local start_row, start_col = target_node:start()
  vim.api.nvim_buf_set_text(buffer, start_row, start_col, start_row, start_col, { 'async ' })
end

-- TODO: this should be set within autocmd for ts and js filetypes only
vim.keymap.set('i', 't', add_async, { buffer = true })
