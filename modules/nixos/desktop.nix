{
  config,
  inputs,
  lib,
  ...
}: {
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
    #   home.sessionVariables is not working -> only on autostarted alacritty
    #   Cannot switch CAPSLOCK and ESC -> using kmonad now which does work
    #   Alt+tab is global opposed to per workspace -> use stacking windows instead?
    #   Blurry/unsharp ui (background, discord) -> scaling of xorg stuff, fixed using settings
    #   KDE apps use light mode -> dolphin works, its just
    #
    #   Blurry windows -> restack
    #   New stacking window not reading keyboard -> refocus
    #
    #   Apps slow to start? -> its fine now
    #   Fullscreen transparancy black screen -> no longer using fullscreen
    #   Spamming SUPER+ up arrow does weird -> fixed
    #   Rows and columns for workspaces (like KDE) -> using stacking windows instead
    #   Using a set amount of workspaces instead of automaticly adding and removing -> Maybe this is fine? would be nice to insert in the start
    desktopManager.cosmic = lib.mkIf config.wortel.cosmic {
      enable = true;
    };
  };
}
