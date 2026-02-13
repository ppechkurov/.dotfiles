-- Taken from [here](https://phelipetls.github.io/posts/async-make-in-nvim-with-lua/).
-- Only works for typescript rn.

local M = {}

--- Runs :make asynchrounously. Opened file required before run.
---@param compiler? string
---@param makeprg? string
function M.make(compiler, makeprg)
  print('Running make...')

  local lines = { '' }
  local winnr = vim.fn.win_getid()
  local bufnr = vim.api.nvim_win_get_buf(winnr)

  -- TODO: Use specific compiler and makeprg for a filetype.
  -- May not work some (telescope, alpha etc.) buffers, for example

  -- local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
  -- local makeprg = vim.api.nvim_buf_get_option(bufnr, 'makeprg')

  if compiler == nil or compiler == '' then
    compiler = 'eslint'
  end

  vim.cmd.compiler(compiler)

  if makeprg == nil or makeprg == '' then
    makeprg = 'npm run lint'
  end

  local cmd = vim.fn.expandcmd(makeprg)

  local function on_event(job_id, data, event)
    if event == 'stdout' or event == 'stderr' then
      if data then
        vim.list_extend(lines, data)
      end
    end

    if event == 'exit' then
      vim.fn.setqflist({}, ' ', {
        title = cmd,
        lines = lines,
        efm = vim.api.nvim_buf_get_option(bufnr, 'errorformat'),
      })
      vim.api.nvim_command('doautocmd QuickFixCmdPost')

      if lines[1] ~= nil then
        vim.cmd.copen()
      end
    end
    print('Make run completed')
  end

  local job_id = vim.fn.jobstart(cmd, {
    on_stderr = on_event,
    on_stdout = on_event,
    on_exit = on_event,
    stdout_buffered = true,
    stderr_buffered = true,
  })
end

return M
