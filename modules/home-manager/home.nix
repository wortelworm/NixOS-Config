{wortel, ...}: let
  username = "wortelworm";
  homedir = "/home/${username}";
in {
  # Home Manager needs a bit of information about you
  # and the paths it should manage.
  home.username = username;
  home.homeDirectory = homedir;

  imports = [
    ./programming
    ./games.nix
    ./misc.nix
  ];

  # environment variables
  home.sessionVariables = {
    SHELL = "nu";
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";

    NIXOS_FLAKE_CONFIG = "${wortel.flakePath}";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  };

  # Cross-Desktop Group, standard specifications from freedesktop.org
  xdg = {
    enable = true;

    # configuration files
    configHome = "${homedir}/.xdg-home/config";

    # data files that are somewhat important, can be synced
    dataHome = "${homedir}/.xdg-home/data";

    # state like logs and last window state
    stateHome = "${homedir}/.xdg-home/state";

    # non-essential (cached) data
    cacheHome = "${homedir}/.xdg-home/cache";

    # Note: runtime dir is automaticly set

    # Default programs
    mimeApps = {
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
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # version of default settings to use
  # CHECK RELEASE NOTES IF UPDATING
  home.stateVersion = "23.11";
}
