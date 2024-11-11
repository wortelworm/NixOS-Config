{pkgs, ...}: {
  home.shellAliases = {
    nd = "nix develop";
    zd = "__f(){ z \"$@\"; nd; }; __f";

    v = "__f(){ z \"$@\"; vi; }; __f";
    vd = "__f(){ z \"$@\"; nd --command nvim +\"Telescope find_files\"; }; __f";
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
      # I could also add git branch to PS1 using PROMPT_COMMAND and set window title
      # Default: PS1='\n\[\033[1;32m\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\$\[\033[0m\]'
      # Add \[ and \] around the colour codes to enable bash to calculate the line length correctly. TODO
      # PS1: \n
      #      \[ \e[0m \e[1;32m \] [\u:\w] \n
      #      \[ \e[0;32m \]  $  \[ \e[0m \]
      initExtra = ''
        PS1='\n\[\e[0m\e[1;32m\][\u:\w]\n\[\e[0;32m\]$ \[\e[0m\]'

        eval "$(zoxide init bash)"
      '';
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
          blur = true;
          opacity = 0.6;
          startup_mode = "Maximized";
          position = {
            x = 100;
            y = 100;
          };
        };
        keyboard.bindings = [
          {
            key = "F11";
            mods = "Control";
            action = "ToggleFullscreen";
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
  };
}
