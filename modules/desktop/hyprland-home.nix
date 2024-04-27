{ lib, wortel, ... }:

let
  mainMod = "SUPER";
in
{
  config = lib.mkIf wortel.hyprland {
    # bar
    programs.eww = {
      enable = true;
      configDir = ./eww;
      # in unstable this can be removed
      # package = pkgs.eww-wayland;
    };

    wayland.windowManager.hyprland.enable = true;

    wayland.windowManager.hyprland.settings = {
      # startup script
      exec-once = toString ./hypr-start.sh;

      # See https://wiki.hyprland.org/Configuring/Monitors/
      monitor = ",preferred,auto,auto";

      # See https://wiki.hyprland.org/Configuring/Variables/ for more
      general = {
        # distance between windows, and the monitor edges
        gaps_in = 4;
        gaps_out = 8;

        layout = "dwindle";
      };

      decoration = {
        rounding = 8;

        inactive_opacity = 0.8;
      };

      input = {
        # not supported in this version yet...
        # scroll_factor = 0.8;
        # todo: touchpad
      };


      # special workspaces exists, idk if I want to use them
      # see also: Qalculate program

      # open app launcher on release of SUPER key
      bindr = [
        # idk why the '_L'
        "${mainMod}, ${mainMod}_L, exec, rofi -show drun -show-icons"
      ];

      # other keybindings
      bind = [
        # main control things
        "${mainMod}, Q, exec, kitty"
        "${mainMod}, E, exec, dolphin"
        "${mainMod}, V, togglefloating"
        "${mainMod}, C, killactive"
        "${mainMod}, M, exit"
        "${mainMod}, V, togglefloating,"
        # todo: screen locking

        # dwindle
        "${mainMod}, P, pseudo,"
        "${mainMod}, J, togglesplit,"
        

        # Move focus with mainMod + arrow keys
        "${mainMod}, left, movefocus, l"
        "${mainMod}, right, movefocus, r"
        "${mainMod}, up, movefocus, u"
        "${mainMod}, down, movefocus, d"

        # Switch workspaces with mainMod + CTRL + arrow
        "${mainMod} CTRL, left, workspace, -1"
        "${mainMod} CTRL, right, workspace, +1"

        # Active window to workspace with mainMod + CTRL + SHIFT + arrow
        "${mainMod} CTRL SHIFT, left, movetoworkspace, -1"
        "${mainMod} CTRL SHIFT, right, movetoworkspace, +1"

        # Switch workspaces with mainMod + [0-9]
        "${mainMod}, 1, workspace, 1"
        "${mainMod}, 2, workspace, 2"
        "${mainMod}, 3, workspace, 3"
        "${mainMod}, 4, workspace, 4"
        "${mainMod}, 5, workspace, 5"
        "${mainMod}, 6, workspace, 6"
        "${mainMod}, 7, workspace, 7"
        "${mainMod}, 8, workspace, 8"
        "${mainMod}, 9, workspace, 9"
        "${mainMod}, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "${mainMod} SHIFT, 1, movetoworkspace, 1"
        "${mainMod} SHIFT, 2, movetoworkspace, 2"
        "${mainMod} SHIFT, 3, movetoworkspace, 3"
        "${mainMod} SHIFT, 4, movetoworkspace, 4"
        "${mainMod} SHIFT, 5, movetoworkspace, 5"
        "${mainMod} SHIFT, 6, movetoworkspace, 6"
        "${mainMod} SHIFT, 7, movetoworkspace, 7"
        "${mainMod} SHIFT, 8, movetoworkspace, 8"
        "${mainMod} SHIFT, 9, movetoworkspace, 9"
        "${mainMod} SHIFT, 0, movetoworkspace, 10"

        # Scroll through existing workspaces with mainMod + scroll
        "${mainMod}, mouse_down, workspace, e+1"
        "${mainMod}, mouse_up, workspace, e-1"

        # special keys
        ",XF86Calculator, exec, qalculate-qt"
        # ",3270_PrintScreen, exec, TODO"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      # allow holding and while locked 
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "${mainMod}, mouse:272, movewindow"
        "${mainMod}, mouse:273, resizewindow"
      ];

      misc = {
        # disable anime girl background
        # disable_hyprland_logo = true;
        force_default_wallpaper = 0;
      };
    };
  };
}