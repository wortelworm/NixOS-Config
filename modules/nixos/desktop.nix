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
    # Issues:
    #   Since the 1.0.0-beta.1.1 all of them are fixed?
    #
    # Missing stuff:
    #   home-manager module
    #   blurred transparent window
    desktopManager.cosmic = lib.mkIf config.wortel.cosmic {
      enable = true;
    };
  };

  programs.niri = lib.mkIf config.wortel.niri {
    enable = true;
    useNautilus = false;
  };
}
