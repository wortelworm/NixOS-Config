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
        # TODO: better shell.
        # ashell would be great, but wifi & bluetooth doesn't work great
        (lib.getExe pkgs-unstable.ashell)

        # Not necessary, but I always manually do it anyways
        "kitty nu --execute btop"
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

      # TODO: more settings?
      #   Authentication Agent
      #   wallpaper (propably hyprpaper)
      #   default windowrules?
      #   Special workspaces?
      #   Faster animations (probably exponential if available)

      # Keybinds mostly following COSMIC, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = [
        # Misc
        "SUPER, T, exec, kitty"
        "SUPER, B, exec, firefox"
        "SUPER, /, exec, ${lib.getExe pkgs.fuzzel}" # TODO: does not seem to be working..
        "SUPER, Q, killactive"
        "SUPER, G, togglefloating"
        "SUPER_SHIFT, Escape, exit" # logout

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
}
