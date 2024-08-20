{ inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.packages = [
    # used by telescope find_files and file_browser
    pkgs.fd
  ];

  # adds and configures neovim using
  # https://github.com/nix-community/nixvim
  # todo: git, zooming in and out,
  # better indentation,
  # latex, competative programming, ...
  # transparency?
  programs.nixvim = {
    enable = true;

    withRuby = false;
    
    # TODO make it look better with transparancy
    colorschemes.onedark = {
        enable = true;
        settings = {
          style = "deep";
          transparent = true;
        };
    };
    
    # keyboard shortcuts below
    clipboard = {
      providers.wl-copy.enable = true;
    };

    opts = {
      relativenumber = true;
      number = true; # Display the absolute line number of the current line

      expandtab = true;
      autoindent = true;
      shiftwidth = 4;
      tabstop = 4;
    };

    # TODO Should be removed when upgrading from 24.05,
    # see plugins.lsp.inlayHints
    package = (import inputs.nixos-unstable { inherit (pkgs) system; }).neovim-unwrapped;

    plugins = {
      lualine.enable = true;
      comment.enable = true;
      nvim-autopairs.enable = true;
      diffview.enable = true;
      neoscroll.enable = true;
      gitsigns.enable = true;
      hop.enable = true;

      # Does not exist yet?
      # guess-indent.enable = true;

      # would be cool to see the background as a toggle,
      # but I would need to configure kitty to work with that
      # transparent.enable = true;

      treesitter = {
        enable = true;
        indent = true;
      };
      toggleterm = {
        enable = true;
        settings = {
          direction = "horizontal";
          size = 15;
        };
      };

      telescope = {
        enable = true;

        extensions = {
          # better selection ui, used for code actions
          ui-select.enable = true;
          fzf-native.enable = true;
          file-browser = {
            enable = true;
            settings.hijack_netrw = true;
          };
        };
      };

      competitest = {
        enable = true;
      };
      
      dap = {
        enable = true;

        extensions.dap-ui.enable = true;

        adapters.servers = {
          # Used for c++ and rust
          codelldb = {
            port = "\${port}";
            executable = {
              command = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
              args = [ "--port" "\${port}" ];
            };
          };
        };

        configurations = {
          # For supported names see :h dap-configuration
          cpp = [
            {
              name = "Debug cpp file";
              type = "codelldb";
              request = "launch";
              program = "\${fileDirname}/\${fileBasenameNoExtension}";
              cwd = "\${workspaceFolder}";
              expressions = "native";
            }
          ];
        };
      };
        
      # TODO this could be cool as a toggle
      # lsp-lines.enable = true;
      lsp = {
        enable = true;
        # TODO enable once upgrading from 24.05
        # inlayHints = true;
        onAttach = ''
          -- LSP Inlay Hints {{{
          if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end
          -- }}}
        '';

        # TODO enable performance stuff once upgrading 24.05

        servers = {
          tsserver.enable = true;
          clangd.enable = true;
          nil-ls.enable = true;

          rust-analyzer = {
            enable = true;
            # these are managed by rustup
            installCargo = false;
            installRustc = false;
            settings = {
              check.command = "clippy";

              # I never use them and they take up a lot of space on the menu
              completion.postfix.enable = false;

              inlayHints.chainingHints.enable = false;
            };
          };
        };
      };
      cmp = {
        enable = true;
        settings.sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
        ];
        settings.mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<C-e>" = "cmp.mapping.close()";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<C-u>" = "cmp.mapping.scroll_docs(-4)";
          "<C-d>" = "cmp.mapping.scroll_docs(4)";
        };
      };

      
      # todo more stuff
    };

    globals.mapleader = " ";

    keymaps = let
      normalVisual =
        lib.mapAttrsToList
        (key: action: {
          mode = [ "n" "v" ];
          inherit action key;
        })
        {
          # show terminal
          "<C-\\>" = "<cmd>ToggleTerm<CR>";

          # hop!
          "f" = "<cmd>HopWord<CR>";

          # telescope & lsp stuff
          "<leader>" = "<NOP>";
          "t" = "<NOP>";

          "tf" = "<cmd>Telescope find_files<CR>";
          "tb" = "<cmd>Telescope buffers<CR>";
          "tc" = "<cmd>Telescope git_bcommits<CR>";
          "tg" = "<cmd>Telescope git_status<CR>";
          "td" = "<cmd>Telescope lsp_definitions<CR>";
          "tR" = "<cmd>Telescope lsp_references<CR>";
          "te" = "<cmd>Telescope file_browser<CR>";

          "<leader>a" = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          "<leader>D" = "<cmd>lua vim.lsp.buf.declaration()<CR>";
          "<leader>h" = "<cmd>lua vim.lsp.buf.hover()<CR>";
          "<leader>r" = "<cmd>lua vim.lsp.buf.rename()<CR>";
          "<leader>o" = "<cmd>lua vim.diagnostic.open_float()<CR>";

          # debugger
          "<F5>" = "<cmd>lua require('dap').continue()<CR>";
          "<F10>" = "<cmd>lua require('dap').step_over()<CR>";
          "<F11>" = "<cmd>lua require('dap').step_into()<CR>";
          "<F12>" = "<cmd>lua require('dap').step_out()<CR>";
          "<leader>b" = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
          "<leader>B" = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";

          # resize windows with arrows
          "<C-Up>"    = "<cmd>resize -2<CR>";
          "<C-Down>"  = "<cmd>resize +2<CR>";
          "<C-Left>"  = "<cmd>vertical resize +2<CR>";
          "<C-Right>" = "<cmd>vertical resize -2<CR>";


          # TODO: make shortcuts for diffview
          # or use telescope to view git stuff
        };
      vni =
        lib.mapAttrsToList
        (key: action: {
          mode = [ "n" "v" "i" ];
          inherit action key;
        })
        {
          # copy, cut, paste
          # TODO: why does pasting work but not copying in visual mode???
          "<CS-c>" = "\\\"+y";
          "<CS-x>" = "\\\"+c";
          "<CS-v>" = "\\\"+p";

          # saving
          "<C-s>" = "<cmd>w<CR>";
        };
      in
        normalVisual ++ vni;
  };
}
