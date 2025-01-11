{lib, ...}: {
  imports = [
    ./ensure-installed.nix
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
    beamLanguages = lib.mkEnableOption "Elixir, gleam and erlang";
    vscode = lib.mkEnableOption "VScode editor, not been used for a while";

    hostname = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = lib.mkDoc "Hostname";
    };

    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "/home/wortelworm/.dotfiles";
      description = lib.mdDoc "Absolute path to this repository's directory";
    };

    ensureInstalled = {
      defaultAll = lib.mkEnableOption "Set default to enabled for all options in this category";

      librariesWGPU = lib.mkEnableOption "Dynamicly linked libraries for web gpu";
      pythonMachineLearning = lib.mkEnableOption "Python libraries for machine learning stuff";
    };
  };

  config = let label_exists = builtins.pathExists ../nixos-label.txt; in {
    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.nixos.label = lib.mkIf label_exists (
      lib.strings.trim (builtins.readFile ../nixos-label.txt)
    );

    warnings = lib.mkIf (!label_exists) [
      "WARNING: Unable to read commit message"
    ];
  };
}
