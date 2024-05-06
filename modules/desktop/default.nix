{ ... }:

{
  # X11 windowing system.
  services.xserver.enable = true;

  # KDE Plasma Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    settings = {
      # custom scaling, '-nolisten tcp' is default
      # X11.ServerArguments="-nolisten tcp -dpi 200";
      # this seems to be the setting since plasma 6
      General.GreeterEnvironment="QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192";
    };
  };
  services.desktopManager.plasma6.enable = true;

  # maybe make the hyprland work properly and
  # test wayfire and sway as well one day...
  imports = [
    ./hyprland.nix
  ];

  # previously enabled plasma 5 by doing:
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
}