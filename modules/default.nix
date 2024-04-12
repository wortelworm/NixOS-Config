{ ... }:

{
  imports = [
    ./users
    ./desktop
    ./services.nix
    ./localization.nix
    ./programs/basics.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}