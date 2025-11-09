{lib, ...}: {
  imports = [
    ./home-manager
    ./nixos
    ./overlays

    ./ensure-installed.nix
    ./unfree.nix
  ];

  options.wortel = {
    gui = lib.mkEnableOption "Enable graphical environment, otherwise only linux terminal";

    cosmic = lib.mkEnableOption "Cosmic desktop environment";
    plasma-home = lib.mkEnableOption "Managing plasma configuration using home-manager";

    fingerprint = lib.mkEnableOption "Fingerprint reader drivers";

    games = lib.mkEnableOption "Game launchers";

    terminalFun = lib.mkEnableOption "Various fun tui's";

    nvidia = lib.mkEnableOption "Nvidia GPU drivers etc FOR WORTELWORM5 ONLY";

    onedrive = lib.mkEnableOption "Manual sync for personal and uni onedrive";

    kanata = lib.mkEnableOption "Kanata, keyboard layout custimization, replacing kmonad";

    # TODO:
    # homelab services options
    # - This needs especially some attention
    # virtualisation settings
    # Rename this to 'services' instead of 'self-hosting'

    self-hosting = {
      # TODO: a bunch of stuffies :)
      #   homepage/glances/widgets
      #
      # Maybe also an global 'enable' option??
      immich = lib.mkEnableOption "Photo and video backup solution";

      radicale = lib.mkEnableOption "CalDAV and CardDAV server";

      syncthing = lib.mkEnableOption "Peer to peer file sync";
    };

    # TODO:
    # Should always enable at least one?
    # What should be my fallback editor?? (Like if no languages are needed)
    textEditors = {
      helix = {
        enable = lib.mkEnableOption "Helix, accidentally my main code editor now";
        local-build = lib.mkEnableOption "Use local build instead of the nixpkgs version";
      };

      nixvim = lib.mkEnableOption "Vim managed through nixvim, with programming support";

      zed-editor = lib.mkEnableOption "Zed code editor";

      vscode = lib.mkEnableOption "VScode editor, I want to replace its role with zed";

      jetbrains-rider = lib.mkEnableOption ".NET IDE from JetBrains. Might also want to enable mono?";
    };

    programmingLanguages = {
      rust = lib.mkEnableOption "Rustup, bacon, toml support";
      beam = lib.mkEnableOption "Elixir, gleam and erlang";
      haskell = lib.mkEnableOption "Ghc, cabal, hlint and lsp";

      typst = lib.mkEnableOption "Typst and tinymist";
      latex = lib.mkEnableOption "TeX Live, mostly supported in nixvim";

      # Note that clang also exists, which is probably better.
      # But I only use this for competative programming which seems to use gcc everywhere
      cpp = lib.mkEnableOption "Support for c++ using the gnu compiler collection";

      # Note: compile sln files using msbuild, not included??
      mono = lib.mkEnableOption "C# support using mono and omnisharp-roslyn";

      dotnet = lib.mkEnableOption ".NET Sdk 9.0";

      # TODO
      # nix = ;
      # nu = ;
      # - maybe omnisharp-roslyn, netcoredbg
      # nodejs = ;
      # python = ;
      # arduino-ide = ;
    };

    xdgAlternative = lib.mkEnableOption "Move all xdg folders to diffent location";

    hostname = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = lib.mkDoc "Hostname";
    };

    flakePath = lib.mkOption {
      type = lib.types.str;
      default = "/home/wortelworm/Config-NixOS";
      description = lib.mdDoc "Absolute path to this repository's directory";
    };

    ensureInstalled = {
      defaultAll = lib.mkEnableOption "Set default to enabled for all options in this category";

      librariesWGPU = lib.mkEnableOption "Dynamicly linked libraries for web gpu";
      pythonMachineLearning = lib.mkEnableOption "Python libraries for machine learning stuff";
      cuda = lib.mkEnableOption "Gpu compute using cudatoolkit";
    };
  };

  config.nix.settings = {
    # Why are flakes and the new commands still experimental??
    experimental-features = ["nix-command" "flakes"];

    # Unfortunatly not enabled by default because of backwards compatibility
    use-xdg-base-directories = true;
  };
}
