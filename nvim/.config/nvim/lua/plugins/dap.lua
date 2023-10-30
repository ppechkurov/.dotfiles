return {
  "mfussenegger/nvim-dap",
  lazy = true,
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "mxsdev/nvim-dap-vscode-js",
    {
      "microsoft/vscode-js-debug",
      version = "1.x",
      build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
    },
  },
  keys = {
    {
      "<leader>d",
      function()
        require("dap").toggle_breakpoint()
      end,
    },
    -- {
    --   '<F5>',
    --   function()
    --     require('dap').continue()
    --   end,
    -- },
    {
      "<F4>",
      function()
        require("dapui").eval()
      end,
      mode = { "n" },
      desc = "Debug: Eval",
    },
  },
  config = function()
    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
    })

    for _, language in ipairs({ "typescript", "javascript" }) do
      require("dap").configurations[language] = {
        -- attach to a node process that has been started with
        -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
        -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
        {
          -- use nvim-dap-vscode-js's pwa-node debug adapter
          type = "pwa-node",
          -- attach to an already running node process with --inspect flag
          -- default port: 9222
          request = "attach",
          -- allows us to pick the process using a picker
          processId = require("dap.utils").pick_process,
          -- name of the debug action you have to select for this config
          name = "Attach debugger to existing `node --inspect` process",
          -- for compiled languages like TypeScript or Svelte.js
          sourceMaps = true,
          -- resolve source maps in nested locations while ignoring node_modules
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
          -- path to src in vite based projects (and most other projects as well)
          cwd = "${workspaceFolder}",
          -- we don't want to debug code inside node_modules, so skip it!
          skipFiles = {
            "${workspaceFolder}/node_modules/**/*.js",
            "${workspaceFolder}/packages/**/node_modules/**/*.js",
            "${workspaceFolder}/packages/**/**/node_modules/**/*.js",
            "<node_internals>/**",
            "node_modules/**",
          },
        },
        -- only if language is javascript, offer this debug action
        language == "javascript"
            and {
              -- use nvim-dap-vscode-js's pwa-node debug adapter
              type = "pwa-node",
              -- launch a new process to attach the debugger to
              request = "launch",
              -- name of the debug action you have to select for this config
              name = "Launch file in new node process",
              -- launch current file
              program = "${file}",
              cwd = "${workspaceFolder}",
            }
          or nil,
      }
    end

    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup({
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    })

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

    -- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    -- dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<F6>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Set Breakpoint" })
  end,
}
