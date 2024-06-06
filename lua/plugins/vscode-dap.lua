require("dap-vscode-js").setup({
  -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
  --debugger_path = "(runtimedir)/lazy/vscode-js-debug",                                         -- Path to vscode-js-debug installation. Changed because I use astroneovim
  debugger_path = "/home/jasyd/.local/share/nvim/lazy/vscode-js-debug",              -- Path to vscode-js-debug installation. Changed because I use astroneovim
  -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
  -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
  -- log_file_level = 2,                                                                          -- Logging level for output to file. Set to false to disable file logging.
  -- log_console_level = vim.log.levels
  --     .TRACE                                                                                   -- Logging level for output to console. Set to false to disable console output.
})

local dap = require("dap")
-- dap.set_log_level('TRACE')
-- vim.lsp.set_log_level("debug")

for _, language in ipairs({ "typescript", "javascript" }) do
  dap.configurations[language] = {
    {
      name = "Run Current Test File (API)",
      type = "pwa-node",
      request = "launch",
      console = "integratedTerminal",
      -- trace = true, -- include debugger info
      runtimeExecutable = "/home/jasyd/.nvm/versions/node/v20.13.1/bin/yarn",
      runtimeArgs = function()
        return {
        "workspace",
        "@canals/api",
        "run",
        "pnpify",
        "mocha",
        vim.fn.expand('%:p'),
        "--import=tsx",
        "--timeout",
        "200000",
        "--require",
        "src/tests/global_setup.ts",
        "--file",
        "src/tests/per_run_setup.ts"
        }
      end,
      env = {
          TZ = "UTC",
          CANALS_IS_TESTING = "1",
          CANALS_ENV = "test"
      },
      sourceMaps = true,
      smartStep = true,
      skipFiles = { "<node_internals>/**" },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      internalConsoleOptions = "neverOpen",
      -- envFile = "apps/legacy/.env",
      killBehavior = "forceful"
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug current integration test",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "--inspect-port=5858",
        "--enable-source-maps",
      },
      program = "${workspaceFolder}/node_modules/jest/bin/jest",
      args = function()
        return {
          "--config",
          "apps/legacy/jest.config.js",
          "--detectOpenHandles",
          "--forceExit",
          "--verbose",
          "--colors",
          "--testTimeout=200000",
          vim.fn.expand('%:t:r') .. '.js', -- :help expand
        }
      end,
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
      env = {
        IS_INTEGRATION = "true",
        AWS_REGION = "us-east-1",
        DB_NAME = "testdb",
        IS_TEST = "test",
        SKIP_TR = "true",
        MAX_LOGIN_ATTEMPTS = "2",
        CCC_IP_WHITELIST = "190.143.111.130/27",
        TZ = "UTC",
        NODE_OPTIONS = "--max-old-space-size=16384"
      },
      envFile = "apps/legacy/.env",
      killBehavior = "forceful"
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug server local",
      -- trace = true, -- include debugger info
      skipFiles = { "<node_internals>/**" },
      runtimeExecutable = "node",
      runtimeArgs = function()
        return {
          "--inspect-port=9298",
          "--enable-source-maps",
        }
      end,
      outFiles = {
        "${workspaceFolder}/apps/legacy/lib/microservices/steve/**/*.js",
        "${workspaceFolder}/apps/legacy/lib/microservices/client/**/*.js",
        "${workspaceFolder}/apps/legacy/lib/microservices/roboAdvisor/**/*.js",
        "!**/node_modules/**"
      },
      program = "${workspaceFolder}/node_modules/serverless/bin/serverless.js",
      args = {
        "offline",
        "start",
        "-s",
        "local",
        "--noPrependStageInUrl",
        "--noTimeout",
      },
      sourceMaps = true,
      port = 9298,
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}/apps/legacy",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
      env = {
        IS_INTEGRATION = "true",
        SLS_DEBUG = "*",
        NODE_OPTIONS = "--max-old-space-size=16384"
      },
      envFile = "apps/legacy/.env",
      killBehavior = "forceful"
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug current test for libs",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "--inspect-port=5858",
        "--enable-source-maps",
      }
      ,
      program = "${workspaceFolder}/node_modules/jest/bin/jest",
      args = function()
        return {
          "--config",
          "libs/utils/providers/adjust/jest.config.js",
          "--detectOpenHandles",
          "--forceExit",
          "--verbose",
          "--colors",
          "--testTimeout=200000",
          vim.fn.expand('%:t:r') .. '.js', -- :help expand
        }
      end,
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
      env = {
        IS_INTEGRATION = "false",
        AWS_REGION = "us-east-1",
        DB_NAME = "testdb",
        IS_TEST = "test",
        SKIP_TR = "true",
        MAX_LOGIN_ATTEMPTS = "2",
        CCC_IP_WHITELIST = "190.143.111.130/27",
        TZ = "UTC",
        NODE_OPTIONS = "--max-old-space-size=16384"
      },
      killBehavior = "forceful"
    },
  }
end

return {}
