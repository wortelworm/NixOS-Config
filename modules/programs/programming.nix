{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
    rustup
    nodejs_21

    mono
    gcc
    gdb

    chromium
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
      package = pkgs.vscodium;
      extensions = [
        pkgs.vscode-extensions.vscodevim.vim
        pkgs.vscode-extensions.jnoortheen.nix-ide
        pkgs.vscode-extensions.rust-lang.rust-analyzer
        # pkgs.vscode-extensions.ms-vscode.cpptools
        # pkgs.vscode-extensions.ms-dotnettools.csharp
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