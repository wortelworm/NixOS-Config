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
    #   It is currenlty very visually glitchy...
    #     Nevermind, maybe only on first launch after config reset??
    #   Since the 1.0.0-beta.1.1 all of them are fixed?
    #
    # Missing stuff:
    #   home-manager module
    #   blurred transparent window
    #
    #
    # Changed settings through settings ui:
    # |- Bluetooth: off? Or is it off by default?
    # |- Desktop
    # |  |- Wallpaper
    # |  |  |- Add folder: ~/Config-NixOS/resources
    # |  |  \- Then select the cubes
    # |  |- Appearance
    # |  |  |- Interface density: Compact
    # |  |  |- Active window hint size: 2
    # |  |  \- Gaps around tiled windows: 2
    # |  |- Panel
    # |  |  |- Automatically hide panel: on
    # |  |  \- Position on screen: Bottom
    # |  |- Dock: disabled
    # |  \- Window management
    # |     |- Focus follows cursor: on
    # |     \- Cursor follows focus: on
    # |- Input devices
    # |  |- Keyboard
    # |  |  |- Compose key: right alt
    # |  |  |- Repeat delay: 1/4 of the bar
    # |  |  \- Repeat rate: 3/4 of the bar
    # |  \-Touchpad
    # |     \- Natural scrolling: on
    # \- Applications
    #    \- Default Applications
    #       \- Terminal: kitty
    #
    # Tiling panel applet:
    #   Tile current workspace: on
    #   New workspace behaviour: Tiled
    #
    desktopManager.cosmic = lib.mkIf config.wortel.cosmic {
      enable = true;
    };
  };

  programs.niri = lib.mkIf config.wortel.niri {
    enable = true;
    useNautilus = false;
  };
}
