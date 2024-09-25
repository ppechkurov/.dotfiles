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

vim.api.nvim_create_autocmd('User', {
  desc = 'close outline when opening telescope because it will open in the outline window',
  pattern = 'TelescopeFindPre',
  command = 'OutlineClose',
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

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd('BufRead', {
  callback = function(opts)
    vim.api.nvim_create_autocmd('BufWinEnter', {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
          not (ft:match('commit') and ft:match('rebase'))
          and last_known_line > 1
          and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys([[g`"]], 'nx', false)
        end
      end,
    })
  end,
})

-- disable autocomment on new line
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  callback = function()
    vim.cmd('set formatoptions-=cro')
  end,
})

-- persistent folds
vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
  pattern = { '*.*' },
  desc = 'save view (folds), when closing file',
  command = 'mkview',
})
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  pattern = { '*.*' },
  desc = 'load view (folds), when opening file',
  command = 'silent! loadview',
})

function leave_snippet()
  if
    ((vim.v.event.old_mode == 's' and vim.v.event.new_mode == 'n') or vim.v.event.old_mode == 'i')
    and require('luasnip').session.current_nodes[vim.api.nvim_get_current_buf()]
    and not require('luasnip').session.jump_active
  then
    require('luasnip').unlink_current()
  end
end

-- stop snippets when you leave to normal mode
vim.api.nvim_command([[
    autocmd ModeChanged * lua leave_snippet()
]])

-- autodetect ansible files
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  pattern = {
    '*/ansible/**/*.yml',
    '*/ansible/**/*.yaml',
    '*/playbooks/*.yml',
    '*/playbooks/*.yaml',
    '*/roles/**/*/*.yml',
  },
  desc = 'autodetect ansible',
  command = 'set filetype=yaml.ansible',
})

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
