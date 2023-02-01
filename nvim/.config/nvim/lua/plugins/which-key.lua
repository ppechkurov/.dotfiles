return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.setup({
      plugins = { spelling = true },
      key_labels = { ["<leader>"] = "SPC" },
    })
    wk.register({
      c = {
        name = "close",
        c = { "<cmd>bdelete<cr>", "current" },
      },
      d = { "delete in no register" },
      e = { "<cmd>Neotree toggle<cr>", "explorer" },
      f = {
        name = "find",
        b = { "<cmd>Telescope buffers<cr>", "buffer" },
        f = { "<cmd>Telescope find_files<cr>", "file" },
        g = { "<cmd>Telescope git_files<cr>", "git" },
        w = { "<cmd>Telescope live_grep<cr>", "word" },
      },
      r = {
        n = { ":IncRename ", "inc rename" },
      },
      p = { "paste previous" },
      s = {
        name = "SFDX",
        d = { "<cmd>Deploy<cr>", "deploy" },
        o = { "<cmd>OpenOrg<cr>", "open default org" },
      },
      l = {
        name = "LSP",
        a = { "action" },
        f = { "format" },
        r = { "rename" },
      },
      x = { "chmod +x" },
    }, { prefix = "<leader>" })
  end,
}
