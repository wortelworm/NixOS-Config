{config, ...}: {
  imports = [
    ./desktop.nix
    ./grub.nix
    ./kanata.nix
    ./localization.nix
    ./nvidia.nix
    ./programs.nix
    ./self-hosting
    ./services.nix
    ./virtualization.nix
  ];

  networking.hostName = config.wortel.hostname;
}
