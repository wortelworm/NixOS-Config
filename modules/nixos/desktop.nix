{
  config,
  lib,
  ...
}: {
  services = lib.mkIf config.wortel.gui {
    xserver.enable = true;

    # sddm is the default display manager for KDE plasma
    displayManager.sddm = {
      enable = true;
      settings.General.DefaultSession = lib.mkIf config.wortel.cosmic "cosmic.desktop";
    };

    desktopManager.plasma6.enable = true;

    # Notes:
    #   A bunch of keybinds can be found in the settings
    #
    # Issues: (hopefully fixed in 25.11)
    #   Bluetooth cpu usage -> workaround in cosmic-applets overlay
    #   Systemd timeout -> workaround with `just kill-cosmic`
    #   Occasional crashes
    #
    # Missing stuff:
    #   home-manager module
    desktopManager.cosmic = lib.mkIf config.wortel.cosmic {
      enable = true;
    };
  };
}
