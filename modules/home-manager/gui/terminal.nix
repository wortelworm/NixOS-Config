{pkgs, ...}: {
  # TODO: maybe ghostty is a beter terminal for minimal configuration

  # Using kitty as terminal for the image support
  programs.kitty = {
    enable = true;
    settings = {
      # Disable unnessicary things
      confirm_os_window_close = 0;
      enable_audio_bell = false;

      # Appearance
      # TODO: more background transparency and blur once cosmic supports it
      background_opacity = "0.85";
      placement_strategy = "top-left";
    };

    font.name = "JetBrainsMono Nerd Font";

    # To test how things are named, run:
    # kitten show-key -m kitty
    keybindings = {
      "ctrl+BACKSPACE" = "send_key ctrl+w";
    };
  };

  # Has been largely replaced by kitty, but
  # here to stay as a backup if I mess up
  #    Note: if alacritty cannot find the font,
  #      it will glitch and do something weird
  programs.alacritty = {
    enable = true;
    settings = {
      general.import = [
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
      font.normal.family = "JetBrainsMono Nerd Font";
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
}
