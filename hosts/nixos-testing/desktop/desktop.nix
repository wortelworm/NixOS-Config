{ config, pkgs, inputs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  # to make hyprland work with nvidia stuff, check out the video
  # 'Nixos and Hyprland - Best Match Ever'
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    # terminal
    kitty

    # bar
    waybar

    # network stuff in the bar
    networkmanagerapplet

    # wallpaper
    swww
    
    # notification daemon
    dunst
    libnotify
  ];
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];



  # Optional, hint electron apps to use wayland:
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}