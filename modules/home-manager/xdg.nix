{config, ...}: {
  # Cross-Desktop Group, standard specifications from freedesktop.org
  xdg = let
    basedir = "${config.home.homeDirectory}/.xdg-home";
  in {
    enable = true;

    # configuration files
    configHome = "${basedir}/config";

    # data files that are somewhat important, can be synced
    dataHome = "${basedir}/data";

    # state like logs and last window state
    stateHome = "${basedir}/state";

    # non-essential (cached) data
    cacheHome = "${basedir}/cache";

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

  # Some applications dont follow the xdg standard :(
  home.sessionVariables = {
    STARSHIP_CONFIG = "${config.xdg.configHome}/starship.toml";
    STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

    IPYTHONDIR = "${config.xdg.configHome}/jupyter";

    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";

    PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";

    # Bash uses this, could be more programs listening
    HISTFILE = "${config.xdg.stateHome}/bash/history";

    # TODO:
    #   Maybe's:
    #       to prevent '~/.java/fonts' from coming back, I might have to
    #           set one of '_JAVA_OPTIONS', 'JAVA_TOOL_OPTIONS' or 'JAVA_FONTS'
    #       do I need to set 'KDEHOME' or the likes?
    #   Unsure how's:
    #       '~/.nix-defexpr', '~/.nix-profile', '~/.nix-channels',
    #       '~/.local/state/nix/', '~/.local/state/home-manager'
    #       vscode :(
    #       mozilla firefox
    #       thunderbird, want to use different mail client anyways
    #       onedrive-gui, should setup sops-nix without gui anyways
    #       '~/.pulsecookie'
  };

  # Some applications dont even have an environment variable to the location
  # Note: steam is configured in 'modules/nixos/programs.nix'
}
