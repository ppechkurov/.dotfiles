local M = {}

function M.get_root_dir()
  local dot_git_path = vim.fn.finddir('.git', '.;')
  local result = vim.fn.fnamemodify(dot_git_path, ':h')
  if result == '.' then
    result = vim.fn.getcwd()
  end
  return result
end

function M.load_latest_session(opts)
  local dir = M.get_root_dir()
  require('resession').load(dir, opts)

  -- if vim.api.nvim_win_get_width(0) >= 120 then
  --   require('neo-tree.command').execute({ action = 'show', dir = dir })
  -- end
end

return M
