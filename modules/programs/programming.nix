{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
    rustup
    nodejs_20

    mono
    gcc
    gdb

    chromium
    sqlite
  ];

  programs = {
    bash = {
      enable = true;
      initExtra = "eval \"$(zoxide init bash)\"";
    };

    git = {
      enable = true;
      userName = "wortelworm";
      userEmail = "wortelworm@gmail.com";
    };
    
    # maybe replace it with neovim one day
    vscode = {
      enable = true;
      # package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        jnoortheen.nix-ide
        rust-lang.rust-analyzer
        ms-vscode.cpptools
        ms-dotnettools.csharp
        arrterian.nix-env-selector
      ];
      userSettings = {
        "explorer.confirmDragAndDrop" = false;
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
        "nix.serverPath" = "nil";
      };
    };
  };
}