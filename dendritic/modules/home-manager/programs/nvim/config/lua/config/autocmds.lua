local function augroup(name)
  return vim.api.nvim_create_augroup('auto_' .. name, { clear = true })
end

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight on yank',
  group = augroup('highlight_yank'),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Close some filetypes with <q>',
  group = augroup('close_with_q'),
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'help',
    'lspinfo',
    'man',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'oil',
    'qf',
    'query',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', 'ZQ', { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Wrap and check for spell in text filetypes',
  group = augroup('wrap_spell'),
  pattern = { 'gitcommit', 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Focus code before showing oil. Without this it will open in outline window',
  group = augroup('outline_oil'),
  pattern = { 'Outline' },
  callback = function()
    vim.keymap.set(
      'n',
      '<BS>',
      '<CMD>OutlineFocusCode<CR><CMD>Oil --float<CR>',
      { desc = 'Focus code before showing oil', buffer = true }
    )
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  desc = 'Fix conceallevel for json files',
  group = augroup('json_conceal'),
  pattern = { 'json', 'jsonc', 'json5' },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  desc = 'Auto create dir when saving a file, in case some intermediate directory does not exist',
  group = augroup('auto_create_dir'),
  callback = function(event)
    if event.match:match('^%w%w+://') then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- disable autocomment on new line
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  callback = function()
    vim.cmd('set formatoptions-=cro')
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  desc = 'Fix indentation in asm files',
  group = augroup('json_conceal'),
  pattern = { 'asm' },
  callback = function()
    vim.opt_local.shiftwidth = 8
  end,
})

vim.api.nvim_create_user_command('LspLogClear', function()
  local lsplogpath = vim.fn.stdpath('state') .. '/lsp.log'
  if io.close(io.open(lsplogpath, 'w+b')) == false then
    vim.notify('Clearning LSP Log failed.', vim.log.levels.WARN)
  end
  print('Lsp log file cleaned up')
end, { nargs = 0 })

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})

--- Run :make async
vim.api.nvim_create_user_command('Make', function(opts)
  local compiler = opts.fargs[1]
  local makeprg = '' .. table.concat(opts.fargs, ' ', 2)
  require('async_make').make(compiler, makeprg)
end, {
  desc = 'Run :make async',
  nargs = '*',
  complete = function()
    return { 'eslint' }
  end,
})

--- Auto reload files via watchers
local function watch_file(bufnr)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == '' then
    return
  end

  local w = vim.uv.new_fs_event()
  w:start(
    filepath,
    {},
    vim.schedule_wrap(function()
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd('checktime')
      end)
    end)
  )

  vim.api.nvim_create_autocmd('BufUnload', {
    buffer = bufnr,
    callback = function()
      w:stop()
    end,
  })
end

vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    watch_file(args.buf)
  end,
})
