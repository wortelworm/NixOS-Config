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
    kitty
    waybar
    swww

    dunst
    libnotify
  ]
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
}