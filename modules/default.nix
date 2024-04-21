{ lib, ... }:

{
  imports = [
    ./users
    ./desktop
    ./services.nix
    ./localization.nix
    ./programs/basics.nix
  ];

  options.wortel = {
    fingerprint = lib.mkEnableOption "Enables fingerprint reader";

    # todo: make this actually do things
    nvdia = lib.mkEnableOption "Enables nvdia GPU";
  };

  config = {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  };
}