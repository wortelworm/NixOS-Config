{ ... }:

{
  imports = [
    ./users
    ./services.nix
    ./localization.nix
    ./programs/misc.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}