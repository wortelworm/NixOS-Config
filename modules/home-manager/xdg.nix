{
  config,
  pkgs,
  ...
}: {
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

    # TODO:
    #   Maybe's:
    #     to prevent '~/.java/fonts' from coming back, I might have to
    #         set one of '_JAVA_OPTIONS', 'JAVA_TOOL_OPTIONS' or 'JAVA_FONTS'
    #     do I need to set 'KDEHOME' or the likes?
    #   Unsure how's:
    #     vscode :(
    #     mozilla firefox
    #     thunderbird, want to use different mail client anyways
    #     '~/.pulsecookie'
  };

  # Some applications dont even have an environment variable to the location
  nixpkgs.overlays = [(final: prev: {
    # Found in https://github.com/ValveSoftware/steam-for-linux/issues/1890#issuecomment-2367103614
    # TODO: test if this works & copy files over
    steam = pkgs.steam.override {
      extraBwarpArgs = [
        "--bind $XDG_STATE_HOME/steam-fake-home $HOME"
        "--unsetenv XDG_CACHE_HOME"
        "--unsetenv XDG_CONFIG_HOME"
        "--unsetenv XDG_DATA_HOME"
        "--unsetenv XDG_STATE_HOME"
      ];
    };
  })];
}
