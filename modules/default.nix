{ lib, ... }:

{
  imports = [
    ./home-manager
    ./nixos
  ];

  options.wortel = {
    cosmic = lib.mkEnableOption "Installs the cosmic desktop environment";
    fingerprint = lib.mkEnableOption "Enables fingerprint reader";
    games = lib.mkEnableOption "Installs game launchers";
    nvidia = lib.mkEnableOption "Enables nvidia GPU drivers etc FOR WORTELWORM5 ONLY";
  };

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
