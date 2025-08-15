{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  # TODO: test if this works
  services.dunst.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # TODO: remove once done
      debug.disable_logs = false;

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = [
        # By default the internal screen is on the left instead of the right
        # Note that the external screen is considered to be the 'first' so changing it's position wont work automagically..
        # "eDP-1,preferred,auto-right,auto"
        "HDMI-A-1, 1920x1080@60, -1920x0, 1"

        # Fallback on all defaults
        ",preferred,auto,auto"
      ];

      exec-once = [
        # Not necessary, but I always manually do it anyways
        "kitty"

        # Configuration of these programs are below
        (lib.getExe pkgs-unstable.ashell)
        (lib.getExe pkgs.hyprpaper)
      ];

      # See https://wiki.hyprland.org/Configuring/Permissions/
      ecosystem = {
        enforce_permissions = true;
      };

      input = {
        # TODO: touchpad natural scrolling

        repeat_rate = 40;
        repeat_delay = 250;
      };

      # Refer to https://wiki.hyprland.org/Configuring/Variables/
      general = {
        gaps_in = 4;
        gaps_out = 8;

        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # TODO: take a proper look at this
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        rounding_power = 2.0;
      };

      animations = {
        bezier = "exponential, 0.15, 1, 0.4, 1";
        animation = [
          # "global, 1, 10, exponential"
          "global,        1,     10,    exponential           "
          "border,        1,     5.39,  exponential           "
          "windows,       1,     4.79,  exponential           "
          "windowsIn,     1,     4.1,   exponential, popin 87%"
          "windowsOut,    1,     1.49,  exponential, popin 87%"
          "fadeIn,        1,     1.73,  exponential           "
          "fadeOut,       1,     1.46,  exponential           "
          "fade,          1,     3.03,  exponential           "
          "layers,        1,     3.81,  exponential           "
          "layersIn,      1,     4,     exponential, fade     "
          "layersOut,     1,     1.5,   exponential, fade     "
          "fadeLayersIn,  1,     1.79,  exponential           "
          "fadeLayersOut, 1,     1.39,  exponential           "
          "workspaces,    1,     1.94,  exponential, fade     "
          "workspacesIn,  1,     1.21,  exponential, fade     "
          "workspacesOut, 1,     1.94,  exponential, fade     "

          # This one is only in a later version of hyprland
          # "zoomFactor,    1,     7,     exponential           "
        ];
      };

      # TODO: more settings?
      #   Screenshot & color picker tools
      #   Scaling of gtk applications seems wrong
      #   Authentication Agent
      #   default windowrules?
      #   Special workspaces?
      #   Faster animations (probably exponential if available)

      # Keybinds mostly following COSMIC, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = [
        # TODO: replace with 'walker' once it's rust rewrite is done and in nixpkgs
        # walker would also need it's own configuration
        "SUPER, slash, exec, ${lib.getExe pkgs.fuzzel}"

        # Misc
        "SUPER, T, exec, kitty"
        "SUPER, B, exec, firefox"
        "SUPER, Q, killactive"
        "SUPER, G, togglefloating"
        "SUPER, Escape, exec, hyprlock" # lockscreen
        "SUPER_SHIFT, Escape, exit" # logout
        "SUPER, S, togglegroup" # Equivalent of COSMIC's stacked windows?

        # Move focus
        "SUPER, left,  movefocus, l"
        "SUPER, h,     movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, l,     movefocus, r"
        "SUPER, up,    movefocus, u"
        "SUPER, k,     movefocus, u"
        "SUPER, down,  movefocus, d"
        "SUPER, j,     movefocus, d"

        # Move windows
        "SUPER_SHIFT, left,  movewindow, l"
        "SUPER_SHIFT, h,     movewindow, l"
        "SUPER_SHIFT, right, movewindow, r"
        "SUPER_SHIFT, l,     movewindow, r"
        "SUPER_SHIFT, up,    movewindow, u"
        "SUPER_SHIFT, k,     movewindow, u"
        "SUPER_SHIFT, down,  movewindow, d"
        "SUPER_SHIFT, j,     movewindow, d"

        # Switch to specific workspace
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move window to specific workspace
        "SUPER_SHIFT, 1, movetoworkspace, 1"
        "SUPER_SHIFT, 2, movetoworkspace, 2"
        "SUPER_SHIFT, 3, movetoworkspace, 3"
        "SUPER_SHIFT, 4, movetoworkspace, 4"
        "SUPER_SHIFT, 5, movetoworkspace, 5"
        "SUPER_SHIFT, 6, movetoworkspace, 6"
        "SUPER_SHIFT, 7, movetoworkspace, 7"
        "SUPER_SHIFT, 8, movetoworkspace, 8"
        "SUPER_SHIFT, 9, movetoworkspace, 9"
        "SUPER_SHIFT, 0, movetoworkspace, 10"
      ];

      # Allow mouse dragging and resizing
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      # Bind with 'repeat' and 'lockscreen'
      bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} -e4 -n2 set 5%-"
      ];

      # Bind with 'lockscreen'
      bindl = [
        # Requires playerctl
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPause, exec, playerctl play-pause"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
    };
  };

  # The toml format requires the unstable package for now
  # There is a home-manager module in 25.11, not in 25.05...
  xdg.configFile."ashell/config.toml".source = (pkgs.formats.toml {}).generate "ashell-config" {
    # TODO: autohide?

    modules = {
      left = ["Workspaces" "Tray" "MediaPlayer"];
      center = ["WindowTitle"];
      right = ["SystemInfo" ["Clock" "Privacy" "Settings"]];
    };

    # Configuring commands for the 'Settings' widget
    settings = {
      # TODO: lock screen & automatic locking
      lock_cmd = "hyprlock &";

      audio_sinks_more_cmd = "${lib.getExe pkgs.pavucontrol} -t 3";
      audio_sources_more_cmd = "${lib.getExe pkgs.pavucontrol} -t 4";

      # TODO: it does not show a scrollbar...
      wifi_more_cmd = lib.getExe' pkgs.networkmanagerapplet "nm-connection-editor";
      vpn_more_cmd = lib.getExe' pkgs.networkmanagerapplet "nm-connection-editor";
      bluetooth_more_cmd = lib.getExe' pkgs.blueman "blueman-manager";

      # TODO: this doesn't work?
      remove_airplane_btn = true;
    };
  };

  services.hyprpaper = {
    enable = true;

    # Don't create the systemd service, only create the settings
    # This way hyprpaper only starts on hyprland
    package = null;

    settings = let
      wallpaper = ../../../resources/wallpaper.png;
    in {
      preload = "${wallpaper}";

      # Show on all monitors
      wallpaper = ", ${wallpaper}";
    };
  };

  programs.hyprlock = {
    enable = true;

    # The way that hyprlock works is that you need to configure every single ui element
    settings = {
      # TODO
      background = {
        monitor = "";
        path = "${../../../resources/wallpaper.png}";
        blur_passes = 1;
      };

      input-field = {
        monitor = "";
        size = "20%, 5%";

        outline_thickness = 3;
        inner_color = "rgba(0, 0, 0, 0.0)"; # no fill

        outer_color = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        check_color = "rgba(00ff99ee) rgba(ff6633ee) 120deg";
        fail_color = "rgba(ff6633ee) rgba(ff0066ee) 40deg";

        # font_color = rgb(143, 143, 143)
        # fade_on_empty = false
        rounding = 15;

        # TODO: capslock color

        # font_family = $font
        # placeholder_text = Input password...
        # fail_text = $PAMFAIL

        # uncomment to use a letter instead of a dot to indicate the typed password
        # dots_text_format = *
        # dots_size = 0.4
        # dots_spacing = 0.3

        # uncomment to use an input indicator that does not show the password length (similar to swaylock's input indicator)
        # hide_input = true

        position = "0, -20";
        # halign = "center"
        # valign = center
      };

      label = [
        # TIME
        {
          monitor = "";
          text = "$TIME"; # ref. https://wiki.hyprland.org/Hypr-Ecosystem/hyprlock/#variable-substitution
          font_size = 90;
          # font_family = $font

          position = "-30, 0";
          halign = "right";
          valign = "top";
        }

        # DATE
        {
          monitor = "";
          text = "cmd[update:60000] date +\"%A, %d %B %Y\""; # update every 60 seconds
          font_size = 25;
          # font_family = $font

          position = "-30, -150";
          halign = "right";
          valign = "top";
        }
      ];
    };
  };
}
