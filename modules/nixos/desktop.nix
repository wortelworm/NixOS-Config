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

    # Cosmic-epoch is working now lets go!

    # Notes
    #   Closing window is mapped to SUPER+Q by default instead of alt+f4
    #   A bunch of keybinds can be found in the settings

    # Issues/missing stuff found:
    #   home.sessionVariables is not working
    #   Cannot switch CAPSLOCK and ESC
    #   Alt+tab is global opposed to per workspace
    #   Blurry/unsharp ui (background, discord)
    #   KDE apps use light mode
    #   
    #   
    #   Apps slow to start?
    #   Fullscreen transparancy black screen
    #   Spamming SUPER+ up arrow does weird
    #   Rows and columns for workspaces (like KDE)
    #   Using a set amount of workspaces instead of automaticly adding and removing
    desktopManager.cosmic = lib.mkIf config.wortel.cosmic {
        enable = true;
    };
  };
}
