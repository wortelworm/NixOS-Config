{ config, inputs, lib, ... }:

{
  imports = [
    inputs.nixos-cosmic.nixosModules.default
  ];

  services = {
    xserver.enable = true;

    # sddm is default display manager for KDE plasma
    displayManager.sddm = {
      enable = true;
      settings.General.GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=2,QT_FONT_DPI=192";
    };

    desktopManager.plasma6.enable = true;

    # Seems like the cache is not working properly yet
    # And my laptop is unable to build it :(
    desktopManager.cosmic = lib.mkIf config.wortel.cosmic {
        enable = true;
    };
  };
}
