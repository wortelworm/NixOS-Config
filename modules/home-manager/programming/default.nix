{
  lib,
  pkgs,
  pkgs-unstable,
  wortel,
  ...
}: {
  imports = [
    ./nixvim
    ./terminal.nix
    ./yazi.nix
    ./zed-editor.nix
  ];

  # All the terminal tooling for various languages
  home.packages = with pkgs;
    [
      chromium
      sqlite

      # nix formatter
      alejandra

      # other languages
      rustup
      nodejs_20
      mono
      gcc
      gdb
      clang-tools
      python313 # First version to respect $PYTHON_HISTORY

      # haskell
      ghc
      cabal-install
      hlint
    ]
    ++ lib.optional wortel.beamLanguages [
      elixir
      gleam
      erlang
    ];

  programs = {
    lazygit = {
      enable = true;
      settings = {
        gui = {
          # This weird format is from golang, see
          # https://pkg.go.dev/time#Layout
          timeFormat = "02 Jan 2006";
          shortTimeFormat = "15:04 today";
        };
        # Using delta as a pager, with a bunch of settings copied from
        #     https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md
        git = {
          paging.pager = "${lib.getExe pkgs.delta} --paging=never --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
          autoFetch = false;
        };
      };
    };

    git = {
      enable = true;

      # Replace the default git diff
      delta.enable = true;

      userName = "wortelworm";
      userEmail = "wortelworm@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = "false";
      };
    };

    # Trying out this new editor
    helix = {
      enable = true;
      package = pkgs-unstable.helix;
      settings = {
        theme = "tokyonight";
        editor = {
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          line-number = "relative";
        };
        keys.normal = {
          "C-g" = [":new" ":insert-output lazygit" ":buffer-close!" ":redraw" ":reload-all"];
          "C-S-i" = ":format";
        };
      };

      # For all default settings, see:
      #     https://github.com/helix-editor/helix/blob/master/languages.toml
      languages = {
        language-server = {
          # Make sure that rust-analayzer component is present, using:
          # `rustup component add rust-analyzer`
          rust-analyzer.config.check.command = "clippy";
        };

        language = [
          {
            name = "nix";
            formatter.command = "alejandra";
            language-servers = ["nixd"];
          }
        ];
      };

      extraPackages = with pkgs; [
        nixd

        # Just like zed, helix expects the haskell lsp to have specific name
        # FIXME: Unsure why specifing "$@" instaed of lsp does not work
        (pkgs.writeShellScriptBin "haskell-language-server-wrapper" ''
          ${lib.getExe' pkgs.haskellPackages.haskell-language-server "haskell-language-server"} "$@"
        '')
      ];
    };

    # Has been replaced by nvim
    # Just as a backup
    vscode = lib.mkIf wortel.vscode {
      enable = true;
      # package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        ms-vscode.cpptools
        ms-dotnettools.csharp
      ];
      userSettings = {
        "explorer.confirmDragAndDrop" = true;
        "explorer.confirmDelete" = false;

        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "git.allowForcePush" = true;

        "vim.smartRelativeLine" = true;
        "vim.useCtrlKeys" = false;
        "vim.handleKeys" = {
          "<C-[>" = true;
        };

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nixd;
        "nix.serverSettings".nixd.formatting.command = ["alejandra"];
      };
    };
  };
}
