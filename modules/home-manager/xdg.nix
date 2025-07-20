{config, ...}: {
  # Cross-Desktop Group, standard specifications from freedesktop.org
  # These settings try to enforce the standards to keep the home directory clean.
  xdg = let
    home = config.home.homeDirectory;
  in {
    enable = true;

    # Configuration files, affects behavior of programs
    configHome = "${home}/.config";

    # Data inherently porable across computers
    dataHome = "${home}/.local/share";

    # Unique for given machine, like logs and history
    stateHome = "${home}/.local/state";

    # Non-essential (cached) data
    cacheHome = "${home}/.cache";

    # Note: runtime dir is automaticly set

    # Default programs
    mimeApps = {
      enable = true;

      # Use 'xdg-mime query filetype [FILE]' to find out the name
      # Look in the directories of $env.XDG_DATA_DIRS/applications
      # For example, '/etc/profiles/per-user/wortelworm/share/applications'
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

    # Rust analyzer expects a specific file under ~/.rustup
    # RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    CARGO_HOME = "${config.xdg.stateHome}/cargo";

    PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";

    STEEL_HOME = "${config.xdg.stateHome}/steel";
    STEEL_LSP_HOME = "${config.xdg.configHome}/steel-lsp";

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
    #       rustup analyzer refering to '~/.rustup' instead of '$RUSTUP_HOME'
    #       vscode :(
    #       mozilla firefox
    #       thunderbird, want to use different mail client anyways
    #       '~/.pulsecookie'
  };

  # Some applications dont even have an environment variable to the location
  # Note: steam is configured in 'modules/nixos/programs.nix'
}
