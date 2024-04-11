{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
  ];

  programs = {
    git = {
      enable = true;
      userName = "wortelworm";
      userEmail = "wortelworm@gmail.com";
    };
    
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = [
        pkgs.vscode-extensions.vscodevim.vim
        pkgs.vscode-extensions.jnoortheen.nix-ide
        # to be added: rust-analyzer
      ];
      userSettings = {
        "explorer.confirmDragAndDrop" = false;

        "git.autofetch" = true;
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;

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