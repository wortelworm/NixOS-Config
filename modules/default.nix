{lib, ...}: {
  imports = [
    ./home-manager
    ./nixos
    ./overlays
  ];

  options.wortel = {
    cosmic = lib.mkEnableOption "Cosmic desktop environment";
    fingerprint = lib.mkEnableOption "Fingerprint reader drivers";
    games = lib.mkEnableOption "Game launchers";
    nvidia = lib.mkEnableOption "Nvidia GPU drivers etc FOR WORTELWORM5 ONLY";
    latex = lib.mkEnableOption "TeX Live and VimTeX";

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
