{ pkgs, lib, ...}:

{
  wayland.windowManager.hyprland.enable = true;
  
  wayland.windowManager.hyprland.settings = {
    # startup script
    exec-once = toString ./hypr-start.sh;

    # See https://wiki.hyprland.org/Configuring/Monitors/
    monitor = ",preferred,auto,auto";

    bind = let mainMod="SUPER"; in [
      "${mainMod}, Q, exec, kitty"
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