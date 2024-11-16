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
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";

    FLAKE = "path:${wortel.flakePath}";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };

  # Default programs
  xdg.mimeApps = {
    enable = true;

    # Use 'xdg-mime query filetype [FILE]' to find out the name
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";

      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "org.kde.gwenview.desktop";
      "image/jpeg" = "org.kde.gwenview.desktop";
      "image/webp" = "org.kde.gwenview.desktop";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # version of default settings to use
  # CHECK RELEASE NOTES IF UPDATING
  home.stateVersion = "23.11";
}
