return {
  'mfussenegger/nvim-dap',
  lazy = true,
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    {
      'microsoft/vscode-js-debug',
      version = '1.x',
      build = 'npm i && npm run compile dapDebugServer && mv dist out',
    },
  },
  keys = {
    {
      '<leader>d',
      function()
        require('dap').toggle_breakpoint()
      end,
    },
    -- F-keys must also trigger lazy-loading: the F5-F7 mappings are
    -- defined in config(), so without these, pressing F5 in a fresh
    -- editor does nothing at all. (F4 already triggers via its entry
    -- below.)
    '<F5>',
    '<F6>',
    '<F7>',
    {
      '<F4>',
      function()
        require('dapui').eval()
      end,
      mode = { 'n' },
      desc = 'Debug: Eval',
    },
  },
  config = function()
    local dap = require('dap')
    local dapui = require('dapui')

    dap.defaults.fallback.terminal_win_cmd = 'tabnew'

    -- Custom breakpoint glyphs (Nerd Font codicons)
    vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'SignColumn' })
    vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'SignColumn', linehl = 'debugPC' })

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        args = { vim.fn.stdpath('data') .. '/lazy/vscode-js-debug' .. '/out/src/dapDebugServer.js', '${port}' },
      },
    }

    dap.adapters.lldb = {
      type = 'server',
      host = '127.0.0.1',
      port = '${port}',
      executable = {
        command = 'lldb-dap',
        args = { '--connection', 'listen://127.0.0.1:${port}' },
      },
    }

    -- GDB ships its own DAP server (needs GDB 14+).
    dap.adapters.gdb = {
      type = 'executable',
      command = 'gdb',
      args = { '--interpreter=dap' },
    }

    local splitStr = function(inputstr)
      local t = {}
      for str in string.gmatch(inputstr, '([^%s]+)') do
        table.insert(t, str)
      end
      return t
    end

    dap.configurations.zig = {
      {
        name = 'Run Program',
        type = 'lldb',
        request = 'launch',
        program = function()
          local co = coroutine.running()
          if co then
            local resume = vim.schedule_wrap(function(item)
              coroutine.resume(co, item)
            end)
            vim.ui.select(vim.fn.glob(vim.fn.getcwd() .. '**/zig-out/**/*', false, true), {
              prompt = 'Select executable',
              kind = 'file',
            }, resume)
            return coroutine.yield()
          end
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = function()
          return splitStr(vim.fn.input('Args: '))
        end,
      },
      {
        name = 'Debug test binary',
        type = 'lldb',
        request = 'launch',
        program = function()
          local co = coroutine.running()
          if co then
            local resume = vim.schedule_wrap(function(item)
              coroutine.resume(co, item)
            end)
            local tests = vim.fn.glob(vim.fn.getcwd() .. '/.zig-cache/o/**/test', false, true)
            table.sort(tests, function(a, b)
              return vim.fn.getftime(a) > vim.fn.getftime(b)
            end)
            local recent = {}
            for i = 1, math.min(10, #tests) do
              recent[#recent + 1] = tests[i]
            end
            table.insert(recent, 1, 'Paste path...')
            vim.ui.select(recent, {
              prompt = 'Select test binary (newest first)',
              kind = 'file',
            }, function(item)
              if item == 'Paste path...' then
                resume(vim.fn.input('Path to binary: '))
              else
                resume(item)
              end
            end)
            return coroutine.yield()
          end
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }

    -- Input terminal ({buf, job}) of the previous run, if still around.
    -- Placeholder buffer shown in the dap-ui slot before the first run.
    local input_term = nil
    local input_placeholder = nil

    dap.configurations.asm = {
      {
        name = 'Run Program (stdin from prompt)',
        type = 'gdb',
        request = 'launch',
        -- Launch through sh so the program's stdin comes from a file:
        -- DAP gives the inferior EOF on stdin and gdb implements no
        -- runInTerminal, so `exec "$0" < "$1"` is the whole trick.
        -- $0 = picked binary, $1 = input file written from the prompt
        -- below, so F5 asks for stdin and launches in one go.
        program = '/bin/sh',
        args = function()
          local co = coroutine.running()
          if co then
            local resume = vim.schedule_wrap(function(item)
              coroutine.resume(co, item)
            end)
            local input_path = vim.fn.getcwd() .. '/.debug-stdin'
            vim.ui.select(vim.fn.glob(vim.fn.getcwd() .. '/bin/*', false, true), {
              prompt = 'Select executable',
              kind = 'file',
            }, function(picked)
              if not picked then
                resume(nil)
                return
              end
              -- Offer last run's input as the default; type \n for newline.
              local previous = ''
              local old = io.open(input_path, 'r')
              if old then
                previous = old:read('*a') or ''
                old:close()
                previous = previous:gsub('\n', '\\n')
              end
              local typed = vim.fn.input('stdin: ', previous)
              -- parens: gsub returns (string, count); write() would
              -- append the count as a second argument without them.
              local out = io.open(input_path, 'w')
              out:write((typed:gsub('\\n', '\n')))
              out:close()
              resume({ '-c', 'exec "$0" < "$1"', picked, input_path })
            end)
            return coroutine.yield()
          end
        end,
        cwd = '${workspaceFolder}',
        -- Entry stop would land in /bin/sh, not your code: leave it off,
        -- <leader>d breakpoints are the real stops (they resolve after
        -- the exec, verified live).
      },
      {
        name = 'Run Program (terminal stdin)',
        type = 'gdb',
        request = 'launch',
        -- Input terminal for the inferior's stdio, shown inside
        -- dap-ui (see the registered element below). No window is
        -- opened here: the buffer is displayed when dap-ui toggles.
        program = function()
          local co = coroutine.running()
          if co then
            local resume = vim.schedule_wrap(function(item)
              coroutine.resume(co, item)
            end)
            vim.ui.select(vim.fn.glob(vim.fn.getcwd() .. '/bin/*', false, true), {
              prompt = 'Select executable',
              kind = 'file',
            }, function(picked)
              if picked then
                -- Build the replacement FIRST: dap-ui refreshes open
                -- windows to input_term while the old one is torn down
                -- below, so the slot never shows a dead buffer.
                local prev = vim.api.nvim_get_current_buf()
                local buf = vim.api.nvim_create_buf(false, true)
                vim.api.nvim_set_current_buf(buf)
                local job = vim.fn.termopen('sleep 100000')
                vim.api.nvim_set_current_buf(prev)
                if job > 0 then
                  -- Esc leaves Terminal mode for Normal mode in THIS
                  -- buffer only (it follows the buffer into dap-ui).
                  -- Note: Esc can no longer be sent as an input byte.
                  vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { buffer = buf })
                  -- Slave side of the terminal's pty, via the job's pid.
                  local link = vim.loop.fs_readlink('/proc/' .. vim.fn.jobpid(job) .. '/fd/0')
                  if link and link:match('^/dev/pts/%d+$') then
                    vim.fn.setenv('DBG_TTY', link)
                  end
                  -- Aim input_term at the replacement BEFORE touching
                  -- the old one: dap-ui refreshes open windows on buffer
                  -- events mid-swap, and anything resolving then must
                  -- land on the new buffer, never the dying one.
                  -- (A window left showing a deleted terminal buffer is
                  -- closed outright, which is how the slot vanished.)
                  local old = input_term
                  input_term = { buf = buf, job = job }
                  -- Windows showing the placeholder or the previous
                  -- terminal (the dap-ui slot) are pointed at the
                  -- replacement explicitly: neither terminal creation
                  -- nor buffer deletion fires the refresh autocmds
                  -- dap-ui listens to, so the slot would otherwise stay
                  -- stale. (A window left on a deleted terminal buffer
                  -- closes outright instead of blanking.)
                  for _, win in ipairs(vim.api.nvim_list_wins()) do
                    local shown = vim.api.nvim_win_get_buf(win)
                    if
                      (old and shown == old.buf)
                      or (input_placeholder and shown == input_placeholder)
                    then
                      vim.api.nvim_win_set_buf(win, buf)
                    end
                  end
                  if old and vim.api.nvim_buf_is_valid(old.buf) then
                    vim.fn.jobstop(old.job)
                    vim.api.nvim_buf_delete(old.buf, { force = true })
                  end
                end
              end
              resume(picked)
            end)
            return coroutine.yield()
          end
        end,
        cwd = '${workspaceFolder}',
        -- Direct launch, no shell wrapper: the entry stop lands in
        -- your _start, as it should.
        stopOnEntry = true,
      },
    }

    for _, language in ipairs({ 'typescript', 'javascript' }) do
      require('dap').configurations[language] = {
        -- attach to a node process that has been started with
        -- `--inspect` for longrunning tasks or `--inspect-brk` for short tasks
        -- npm script -> `node --inspect-brk ./node_modules/.bin/vite dev`
        {
          -- use nvim-dap-vscode-js's pwa-node debug adapter
          type = 'pwa-node',
          -- attach to an already running node process with --inspect flag
          -- default port: 9222
          request = 'attach',
          -- allows us to pick the process using a picker
          processId = require('dap.utils').pick_process,
          -- name of the debug action you have to select for this config
          name = 'Attach debugger to existing `node --inspect` process',
          -- for compiled languages like TypeScript or Svelte.js
          sourceMaps = true,
          -- resolve source maps in nested locations while ignoring node_modules
          resolveSourceMapLocations = {
            '${workspaceFolder}/**',
            '!**/node_modules/**',
          },
          -- path to src in vite based projects (and most other projects as well)
          cwd = '${workspaceFolder}',
          -- we don't want to debug code inside node_modules, so skip it!
          skipFiles = {
            '${workspaceFolder}/node_modules/**/*.js',
            '${workspaceFolder}/packages/**/node_modules/**/*.js',
            '${workspaceFolder}/packages/**/**/node_modules/**/*.js',
            '<node_internals>/**',
            'node_modules/**',
          },
        },
        -- only if language is javascript, offer this debug action
        language == 'javascript' and {
          -- use nvim-dap-vscode-js's pwa-node debug adapter
          type = 'pwa-node',
          -- launch a new process to attach the debugger to
          request = 'launch',
          -- name of the debug action you have to select for this config
          name = 'Launch file in new node process',
          -- launch current file
          program = '${file}',
          cwd = '${workspaceFolder}',
        } or nil,
      }
    end

    -- Input terminal live here: placeholder text until the first run.
    local function input_buffer()
      if input_term and vim.api.nvim_buf_is_valid(input_term.buf) then
        return input_term.buf
      end
      if not (input_placeholder and vim.api.nvim_buf_is_valid(input_placeholder)) then
        input_placeholder = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(input_placeholder, 0, -1, false, { 'No input terminal yet - press F5.' })
        vim.bo[input_placeholder].modifiable = false
      end
      return input_placeholder
    end

    dapui.register_element('input_term', {
      render = function() end,
      buffer = input_buffer,
      allow_without_session = true,
    })

    dapui.setup({
      -- Layouts are dap-ui's defaults plus input_term in the bottom tray.
      layouts = {
        {
          elements = {
            { id = 'scopes', size = 0.25 },
            { id = 'breakpoints', size = 0.25 },
            { id = 'stacks', size = 0.25 },
            { id = 'watches', size = 0.25 },
          },
          size = 40,
          position = 'left',
        },
        {
          -- repl plus the input terminal; no console element: nothing
          -- in this workflow writes to it, so it sat here empty.
          elements = { 'repl', 'input_term' },
          size = 10,
          position = 'bottom',
        },
      },
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    })

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

    -- dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    -- dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- F5 that never resumes a corpse: once the inferior has exited,
    -- the session object lingers and plain continue() would offer
    -- Terminate/Pause/Restart instead of a fresh run. Drop the dead
    -- session first; post-mortem inspection (F7) still works until then.
    local exited = false
    dap.listeners.after.event_exited['fresh_on_relaunch'] = function()
      exited = true
    end
    dap.listeners.after.event_initialized['fresh_on_relaunch'] = function()
      exited = false
    end
    local function smart_continue()
      if exited then
        exited = false
        dap.close()
      end
      dap.continue()
    end

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
    vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
    vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
    vim.keymap.set('n', '<F5>', smart_continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<F6>', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end, { desc = 'Debug: Set Breakpoint' })
  end,
}
