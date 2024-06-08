{ lib, ... }:

{
  imports = [
    ./home-manager
    ./nixos
  ];

  options.wortel = {
    fingerprint = lib.mkEnableOption "Enables fingerprint reader";
    games = lib.mkEnableOption "Installs game launchers";
    newerPlasma = lib.mkEnableOption "Switches from plasma 5 to plasma 6";
    nvidia = lib.mkEnableOption "Enables nvidia GPU drivers etc FOR WORTELWORM5 ONLY";
  };

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}