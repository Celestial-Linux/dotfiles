return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mfussenegger/nvim-jdtls" },
    opts = {
      setup = {
        jdtls = function(_, _opts)
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
              require("lazyvim.util").on_attach(function(_, buffer)
                local wk = require "which-key"

                -- Normal mode mappings
                wk.add {
                  {
                    mode = "n",
                    buffer = buffer,
                    { "<leader>d", group = "jdtls" },
                    { "<leader>di", function() require("jdtls").organize_imports() end, desc = "Organize Imports" },
                    { "<leader>dt", function() require("jdtls").test_class() end, desc = "Test Class" },
                    {
                      "<leader>dn",
                      function() require("jdtls").test_nearest_method() end,
                      desc = "Test Nearest Method",
                    },
                    { "<leader>de", function() require("jdtls").extract_variable() end, desc = "Extract Variable" },
                    { "<leader>cf", function() vim.lsp.buf.formatting() end, desc = "Format" },
                  },
                }

                -- Visual mode mappings
                wk.add {
                  {
                    mode = "v",
                    buffer = buffer,
                    { "<leader>d", group = "jdtls" },
                    {
                      "<leader>de",
                      function() require("jdtls").extract_variable(true) end,
                      desc = "Extract Variable",
                    },
                    {
                      "<leader>dm",
                      function() require("jdtls").extract_method(true) end,
                      desc = "Extract Method",
                    },
                  },
                }
              end)

              local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
              -- vim.lsp.set_log_level('DEBUG')
              local workspace_dir = "/home/jake/.workspace/" .. project_name -- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
              local config = {
                -- The command that starts the language server
                -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
                cmd = {
                  "java",
                  "-javaagent:/home/jake/.local/share/java/lombok.jar",
                  -- '-Xbootclasspath/a:/home/jake/.local/share/java/lombok.jar',
                  "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                  "-Dosgi.bundles.defaultStartLevel=4",
                  "-Declipse.product=org.eclipse.jdt.ls.core.product",
                  "-Dlog.protocol=true",
                  "-Dlog.level=ALL",
                  -- '-noverify',
                  "-Xms1g",
                  "--add-modules=ALL-SYSTEM",
                  "--add-opens",
                  "java.base/java.util=ALL-UNNAMED",
                  "--add-opens",
                  "java.base/java.lang=ALL-UNNAMED",
                  "-jar",
                  "/var/data/nvim/mason/share/jdtls/plugins/org.eclipse.equinox.launcher.jar",
                  "-configuration",
                  "/var/data/nvim/mason/packages/jdtls/config_linux",
                  "-data",
                  workspace_dir,
                },

                -- This is the default if not provided, you can remove it. Or adjust as needed.
                -- One dedicated LSP server & client will be started per unique root_dir
                root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew" },

                -- Here you can configure eclipse.jdt.ls specific settings
                -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
                -- for a list of options
                settings = {
                  java = {},
                },
                handlers = {
                  ["language/status"] = function(_, result)
                    -- print(result)
                  end,
                  ["$/progress"] = function(_, result, ctx)
                    -- disable progress updates.
                  end,
                },
              }
              require("jdtls").start_or_attach(config)
            end,
          })
          return true
        end,
      },
    },
  },
}
