{ lib, ... }:

{
  imports = [
    ./users
    ./desktop
    ./grub.nix
    ./nvidia.nix
    ./services.nix
    ./localization.nix
    ./programs/basics.nix
  ];

  options.wortel = {
    fingerprint = lib.mkEnableOption "Enables fingerprint reader";

    nvidia = lib.mkEnableOption "Enables nvidia GPU drivers etc FOR WORTELWORM5 ONLY";

    hyprland = lib.mkEnableOption "Enables testing hyprland";
  };

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}