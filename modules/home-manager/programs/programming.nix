{ pkgs, ... }:

{
  imports = [
    ./neovim.nix
  ];

  home.packages = with pkgs; [
    nil
    rustup
    nodejs_20

    mono
    gcc gdb clang-tools

    chromium
    sqlite
  ];

  home.shellAliases = {
    v = "f(){ z \"$@\"; vi; }; f";
    vi = "nvim +\"Telescope find_files\"";
  };

  programs = {
    bash = {
      enable = true;
      initExtra = "eval \"$(zoxide init bash)\"";
    };

    git = {
      enable = true;
      userName = "wortelworm";
      userEmail = "wortelworm@gmail.com";
      extraConfig.init.defaultBranch = "main";
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
