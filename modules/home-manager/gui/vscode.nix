{
  lib,
  pkgs,
  wortel,
  ...
}: {
  # Has been replaced by nvim
  # Just as a backup
  programs.vscode = lib.mkIf wortel.textEditors.vscode {
    enable = true;
    # package = pkgs.vscodium;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # vscodevim.vim
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
