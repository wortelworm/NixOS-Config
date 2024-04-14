{ pkgs, ... }:

{

  # to make hyprland work with nvidia stuff, check out the video
  # 'Nixos and Hyprland - Best Match Ever'
  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    # lets try to not have this enabled
    # xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # terminal, lets try using konsole instead
    # kitty

    # bar
    waybar

    # network stuff in the bar
    networkmanagerapplet

    # app launcher
    rofi-wayland

    # wallpaper
    swww

    # notification daemon
    dunst
    libnotify
  ];

  # I believe this enables things like file opening
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

}