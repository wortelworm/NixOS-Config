{
  lib,
  pkgs,
  wortel,
  ...
}: {
  programs.nixvim = {
    # Automaticly open and close dap-ui
    extraConfigLuaPost =
      # lua
      ''
        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.before.attach.dapui_config = dapui.open
        dap.listeners.before.launch.dapui_config = dapui.open
        dap.listeners.before.event_terminated.dapui_config = dapui.close
        dap.listeners.before.event_exited.dapui_config = dapui.close
      '';

    plugins = {
      competitest = {
        enable = true;
        settings = {
          template_file.cpp = "${./cp-template.cpp}";
          evaluate_template_modifiers = true;
          date_format = "%Y-%m-%d %H:%M:%S";

          testcases_use_single_file = true;
          testcases_single_file_format = "./tests/$(FNOEXT).testcases";

          compile_command = {
            # C++ is overwritten from default configuration
            # to move the executables into a subdirectory
            cpp = {
              exec = "g++";
              args = ["-Wall" "$(FNAME)" "-o" "./bin/$(FNOEXT)"];
            };
          };
          run_command = {
            cpp.exec = "./bin/$(FNOEXT)";
            nu = {
              exec = lib.getExe pkgs.nushell;
              args = ["--stdin" "--error-style" "plain" "$(FNAME)"];
            };
            elixir = lib.mkIf wortel.beamLanguages {
              exec = "elixir";
              args = ["$(FNAME)"];
            };
          };
        };
      };

      dap = {
        enable = true;

        signs = {
          dapBreakpoint.text = " ";
          dapBreakpointCondition.text = " ";
          dapBreakpointRejected.text = " ";
          dapLogPoint.text = " ";
          dapStopped.text = " ";
        };

        adapters.servers = {
          # Used for c++ and rust
          codelldb = {
            port = "\${port}";
            executable = {
              command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
              args = ["--port" "\${port}"];
            };
          };
        };

        # For all supported subsitutions see :h dap-configuration
        configurations = {
          cpp = [
            {
              name = "Debug cpp file";
              type = "codelldb";
              request = "launch";

              cwd = "\${workspaceFolder}";
              expressions = "native";
              program.__raw =
                # lua
                ''
                  function()
                    local sourceFile = vim.fn.expand("%");
                    local resFolder = vim.fn.expand("%:h") .. "/bin/"
                    local exeFile = resFolder .. vim.fn.expand("%:t:r") .. ".dap";

                    -- The -g flag compiles with debug info
                    vim.system({"mkdir", resFolder}):wait();
                    vim.system({"g++", "-g", sourceFile, "-o", exeFile}):wait();

                    return exeFile;
                  end
                '';
            }
          ];
          rust = [
            {
              # Did not get this working: https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#cargo-support
              # So instead this follows: https://alighorab.github.io/neovim/nvim-dap/
              name = "Debug cargo project";
              type = "codelldb";
              request = "launch";

              expressions = "native";
              program.__raw =
                # lua
                ''
                  function ()
                    os.execute("cargo build &> /dev/null")
                    return "target/debug/''${workspaceFolderBasename}"
                  end
                '';
            }
          ];
        };
      };

      dap-ui = {
        enable = true;

        settings.layouts = [
          {
            elements = [
              {
                id = "breakpoints";
                size = 0.25;
              }
              {
                id = "stacks";
                size = 0.25;
              }
              {
                id = "watches";
                size = 0.25;
              }
              {
                id = "scopes";
                size = 0.25;
              }
            ];
            position = "left";
            size = 40;
          }
          {
            elements = [
              {
                id = "repl";
                size = 0.7;
              }
              {
                id = "console";
                size = 0.3;
              }
            ];
            position = "bottom";
            size = 10;
          }
        ];
      };
    };
  };
}
