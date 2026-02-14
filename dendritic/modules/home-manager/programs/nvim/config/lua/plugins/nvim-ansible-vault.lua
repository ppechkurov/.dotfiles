return {
  'apayu/nvim-ansible-vault',
  config = function()
    require('ansible-vault').setup({
      -- Optional custom configuration
      vault_password_files = { '.vault_pass', '.vault-pass', 'pass.sh' },
      patterns = { '*/host_vars/*/vault.yml', '*/group_vars/*/vault.yml', '*.vault.*' },
      vault_id = 'default',
    })
  end,
  event = 'BufReadPre *.vault.*', -- Load only when opening vault files
}
