{ ... }:

{
  # X11 windowing system.
  services.xserver.enable = true;

  # KDE Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  services.displayManager.sddm = {
    enable = true;
    # Altough expirimental, scaling seems to work better in sddm wayland
    wayland.enable = true;
  };
  services.xserver.desktopManager.plasma5.enable = true;

  # todo: hyprland, wayfire and sway?
  imports = [
    ./hyprland.nix
  ];
}