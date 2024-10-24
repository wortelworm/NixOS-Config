{wortel, ...}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "wortelworm";
  home.homeDirectory = "/home/wortelworm";

  imports = [
    ./programs
    # ./plasma-home.nix
  ];

  # manage plain files
  home.file = {
  };

  # environment variables
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";

    FLAKE = "path:${wortel.flakePath}";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };

  programs.kitty = {
    enable = true;
    extraConfig = "confirm_os_window_close 0";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # version of default settings to use
  # CHECK RELEASE NOTES IF UPDATING
  home.stateVersion = "23.11";
}
