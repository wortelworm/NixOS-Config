{ config, pkgs, ... }:

{
  # KDE Plasma Desktop Environment.
  services = if config.wortel.newerPlasma then {
    # plasma 6
    xserver.enable = true;
    displayManager.sddm = {
      enable = true;
      settings.General.GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192";
    };
    desktopManager.plasma6.enable = true;

  } else {
    # plasma 5
    xserver.enable = true;
    displayManager.sddm = {
      enable = true;
      settings.X11.ServerArguments = "-nolisten tcp -dpi 200";
    };
    xserver.desktopManager.plasma5.enable = true;
  };
  # replace terminal
  environment = {
    plasma6.excludePackages = [ pkgs.kdePackages.konsole ];
    systemPackages = [ pkgs.kitty ];
  };


  # maybe also have gnome installed?
}
