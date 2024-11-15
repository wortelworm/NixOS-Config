{wortel, ...}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "wortelworm";
  home.homeDirectory = "/home/wortelworm";

  imports = [
    ./programming
    ./games.nix
    ./misc.nix
  ];

  # environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";

    FLAKE = "path:${wortel.flakePath}";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # version of default settings to use
  # CHECK RELEASE NOTES IF UPDATING
  home.stateVersion = "23.11";
}
