-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local function sfdx(args)
  vim.fn.jobstart(args, {
    on_stdout = function(id, data)
      print(vim.fn.join(data))
    end,
    on_stderr = function(id, data)
      print(vim.fn.join(data))
    end,
    on_exit = function() end,
  })
end

vim.api.nvim_create_user_command("Deploy", function()
  sfdx("sfdx force:source:deploy -p" .. " " .. vim.fn.expand("%"))
end, {})

vim.api.nvim_create_user_command("OpenOrg", function()
  sfdx("sfdx force:org:open")
end, {})
