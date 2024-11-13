{pkgs, ...}: {
  imports = [
    ./nixvim
    ./terminal.nix
  ];

  home.packages = with pkgs; [
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
  ];

  programs = {
    git = {
      enable = true;
      userName = "wortelworm";
      userEmail = "wortelworm@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = "false";
      };
    };

    # WIP
    # lf = {
    #   enable = true;
    #
    #   commands = {
    #     # something with xdragon
    #     editor-open = ''vi $f'';
    #
    #     # use ripdrag
    #
    #     mkdir = ''
    #       ''${{
    #         printf "Directory Name: "
    #         read DIR
    #         mkdir DIR
    #       }}
    #     '';
    #   };
    # };

    # Has been replaced by nvim
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
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "nix.serverSettings".nixd.formatting.command = ["alejandra"];
      };
    };
  };
}
