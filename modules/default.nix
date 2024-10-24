{lib, ...}: {
  imports = [
    ./home-manager
    ./nixos
  ];

  options.wortel = {
    cosmic = lib.mkEnableOption "Installs the cosmic desktop environment";
    fingerprint = lib.mkEnableOption "Enables fingerprint reader";
    games = lib.mkEnableOption "Installs game launchers";
    nvidia = lib.mkEnableOption "Enables nvidia GPU drivers etc FOR WORTELWORM5 ONLY";

    hostname = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = lib.mkDoc "Hostname like 'wortelworm5'";
    };

    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "/home/wortelworm/.dotfiles";
      description = lib.mdDoc "Absolute path to this repository's directory";
    };
  };

  config = {
    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
