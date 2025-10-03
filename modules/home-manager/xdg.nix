{
  config,
  lib,
  wortel,
  ...
}: {
  # Cross-Desktop Group, standard specifications from freedesktop.org
  # These settings try to enforce the standards to keep the home directory clean.
  xdg = let
    home = config.home.homeDirectory;

    directories =
      if wortel.xdgAlternative
      then {
        # These locations are chosen because data of flatpaks are put in ~/.var/app
        # And you cannot easily change that location...
        configHome = "${home}/.var/config";
        dataHome = "${home}/.var/data";
        stateHome = "${home}/.var/state";
        cacheHome = "${home}/.var/cache";
      }
      else {
        # Configuration files, affects behavior of programs
        configHome = "${home}/.config";

        # Data inherently porable across computers
        dataHome = "${home}/.local/share";

        # Unique for given machine, like logs and history
        stateHome = "${home}/.local/state";

        # Non-essential (cached) data
        cacheHome = "${home}/.cache";
      };
  in {
    enable = true;

    inherit (directories) configHome dataHome stateHome cacheHome;

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

    # Add steam's share directory for the ".desktop" files
    # Because steam has a different home directory
    systemDirs.data = lib.optionals wortel.games [
      "${directories.stateHome}/steam-home/.local/share"
    ];
  };

  # Some applications dont follow the xdg standard by default :(
  home.sessionVariables = {
    STARSHIP_CONFIG = "${config.xdg.configHome}/starship.toml";
    STARSHIP_CACHE = "${config.xdg.cacheHome}/starship";

    ZELLIJ_CONFIG_DIR = "${config.xdg.configHome}/zellij";

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
    #   '~/.local/state/nix/', '~/.local/state/home-manager' !!!
    #   `.profile`, `.bashrc`, `bash_profile`
    #    '~/.pulsecookie', '~/.java/fonts': might be fixed if they are in flatpaks now
    #
    #   Then I could also move steam, rustup?, firefox, thunderbird, ... there?
    #
    #   ~/.e4mc_cache is from a minecraft mod... Now that prismlauncher is installed as a flatpack it shouldn't be a problem right?
    #
    #   Old unsure how's:
    #       rustup analyzer refering to '~/.rustup' instead of '$RUSTUP_HOME'
    #       vscode, but I'm gonna use zed instead
    #       mozilla firefox, maybe look at libreoffice with different home.
    #       thunderbird, want to use different mail client anyways

    # NOTE:
    #     For ssh keys, I will still continue to use ~/.ssh
    #       The configuration is done system wide
  };

  # Some applications dont even have an environment variable to the location
  # Note: steam is configured in 'modules/nixos/programs.nix'
}
