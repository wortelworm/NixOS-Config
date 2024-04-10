{ pkgs, lib, ...}:

{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = ./hypr-start.sh
    };
  };
}