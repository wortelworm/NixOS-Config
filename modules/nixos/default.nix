{config, ...}: {
  imports = [
    ./desktop.nix
    ./grub.nix
    ./kmonad.nix
    ./localization.nix
    ./nvidia.nix
    ./programs.nix
    ./services.nix
    ./virtualization.nix
  ];

  networking.hostName = config.wortel.hostname;
}
