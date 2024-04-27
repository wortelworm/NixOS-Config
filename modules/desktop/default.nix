{ ... }:

{
  # X11 windowing system.
  services.xserver.enable = true;

  # KDE Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  services.displayManager.sddm = {
    enable = true;
    # custom scaling, '-nolisten tcp' is default
    settings.X11.ServerArguments="-nolisten tcp -dpi 200";
  };
  services.xserver.desktopManager.plasma5.enable = true;

  # maybe make the hyprland work properly and
  # test wayfire and sway as well one day...
  imports = [
    ./hyprland.nix
  ];
}