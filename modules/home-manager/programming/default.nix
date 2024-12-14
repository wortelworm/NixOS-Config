{
  lib,
  pkgs,
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

      # nix lsp and formatter
      nil
      alejandra

      # other languages
      rustup
      nodejs_20
      mono
      gcc
      gdb
      clang-tools
      python3

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
      # Using delta as a pager, with a bunch of settings copied from
      #     https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md
      settings = {
        gui = {
          timeFormat = "02 Jan 2006";
          shortTimeFormat = "15:04 today";
        };
        git.paging.pager = "${lib.getExe pkgs.delta} --paging=never --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
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

    # Has been replaced by nvim and zed
    # Just as a backup
    vscode = {
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
