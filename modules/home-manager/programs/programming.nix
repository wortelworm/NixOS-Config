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
    nd = "nix develop";
    zd = "f(){ z \"$@\"; nd; }; f";

    v  = "f(){ z \"$@\"; vi; }; f";
    vd = "f(){ z \"$@\"; nd --command nvim +\"Telescope find_files\"; }; f";
    vi = "nvim +\"Telescope find_files\"";

    cc = "cargo clippy";
    ct = "cargo test";
    cr = "cargo run";
    
    gs = "git status";

    amc = "alacritty msg config";

    f = "fastfetch";
  };

  programs = {
    bash = {
      enable = true;
      initExtra = ''
        eval "$(zoxide init bash)"
      '';
    };

    git = {
      enable = true;
      userName = "wortelworm";
      userEmail = "wortelworm@gmail.com";
      extraConfig.init.defaultBranch = "main";
    };

    alacritty = {
      enable = true;
      settings = {
        import = [
            "${pkgs.alacritty-theme}/xterm.toml"
        ];
        cursor = {
          style = {
            shape = "Beam";
            blinking = "On";
          };
          vi_mode_style = {
            shape = "Block";
            blinking = "Off";
          };
          blink_interval = 500;
          thickness = 0.175;
        };
        font.normal.family = "Hack";
        window = {
          opacity = 0.6;
          startup_mode = "Fullscreen";
          position = { x = 100; y = 100; };
        };
        keyboard.bindings = [
          {
            key = "F11";
            action = "ToggleFullscreen";
          }
          {
            key = "Escape";
            mode = "~AppCursor | ~AppKeypad | ~Vi";
            action = "ToggleViMode";
          }
          {
            key = "Backspace";
            mods = "Control";
            # this is ^W
            chars = "\\u0017";
          }
        ];
      };
    };
    
    # has been mostly replaced by nvim
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
