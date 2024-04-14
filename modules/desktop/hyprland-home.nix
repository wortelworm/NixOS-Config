{ ... }:

let
  mainMod = "SUPER";
in
{
  wayland.windowManager.hyprland.enable = true;

  wayland.windowManager.hyprland.settings = {
    # startup script
    exec-once = toString ./hypr-start.sh;

    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor = ",preferred,auto,auto";

    # open app launcher on release of SUPER key
    bindr = [
      # idk why the '_L'
      "${mainMod}, ${mainMod}_L, exec, rofi -show drun -show-icons"
    ];

    # other keybindings
    bind = [
      "${mainMod}, Q, exec, konsole"
      "${mainMod}, E, exec, dolphin"
      "${mainMod}, V, togglefloating"
      "${mainMod}, C, killactive"
      "${mainMod}, M, exit"
    ];

    misc = {
      # disable anime girl background
      # disable_hyprland_logo = true;
      force_default_wallpaper = 0;
    };
  };
}