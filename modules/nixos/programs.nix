{
  config,
  lib,
  pkgs,
  ...
}: {
  # Notes on programs not added:
  #     bottles: running windows programs
  #         But does not work for microsoft visual studio and microsoft office
  #     ripgrep-all: like ripgrep but many more file formats
  #         adds ~225MiB of dependencies for something I almost never gonna use
  #   Browser things in the terminal:
  #     termscp: filezilla in the terminal
  #     browsh: browser in terminal, may be a lifesaver in a weird senario
  #     wiki-tui:
  #         really cool but does not work for math images
  #     ncspot:
  #         ncurses spotify client

  # These are the only non-homemanager programs in path
  environment.systemPackages = with pkgs;
    [
      # Nix utils
      nh
      nix-inspect

      # System utils
      dust
      btop
      netscanner
      fetch-battery

      # Programming
      lazygit
      just
      tokei
      bat
    ]
    ++ lib.optionals config.wortel.gui [
      firefox
      libreoffice-qt # qt version because I'm using kde
      keepassxc
      alacritty

      # Disk partitions (I basically never use this anymore)
      # gparted
      # ntfs3g
    ];

  # TODO: declaring installed flatpaks via home-manager or globally or something
  services.flatpak.enable = config.wortel.gui;

  # font, used automaticly by kitty
  # I want to have support for nerdfonts and ligatures
  #     Hack: does not have ligatures
  #     FiraCode: weird g
  #     JetBrainsMono:
  #         Text is more vertical space,
  #         bad for things like btop
  #         in kitty it is fine, int alacritty its worse
  fonts.packages = with pkgs;
    lib.optionals config.wortel.gui [
      nerd-fonts.jetbrains-mono
    ];

  # TODO: check, maybe the gnome ssh key agent is nicer
  services.gnome.gcr-ssh-agent.enable = false;

  programs.ssh = {
    # Starts OpenSSH agent on login, so don't have to type
    # passphrase on every git push (ssh connection)
    startAgent = true;

    # 'confirm': add key after first use, confirm every use after that
    extraConfig = ''
      AddKeysToAgent confirm
    '';

    knownHosts = {
      "github" = {
        # Source: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
        hostNames = ["github.com"];
      };

      # TODO: check publicKey. Only the fingerprint can be found here:
      # https://git.science.uu.nl/help/instance_configuration
      # "uni gitlab" = {
      #   publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPEbg2mBaox7ZwGa/0o+JM+EUWPnPtknfCltzm1Xap9x";
      #   hostNames = ["git.science.uu.nl"];
      # };
    };
  };

  programs.kdeconnect.enable = config.wortel.gui;

  # Could be cool to use in like 2028
  # programs.ladybird.enable = true;

  # It has to be installed system wide...
  programs.steam = lib.mkIf config.wortel.games {
    enable = true;
    # Open ports in the firewall for Steam Remote Play
    remotePlay.openFirewall = false;
    # Open ports in the firewall for Source Dedicated Server
    dedicatedServer.openFirewall = false;

    # By default, steam does not follow the XDG conventions,
    # so instead it gets its own fake home directory.
    # Found in https://github.com/ValveSoftware/steam-for-linux/issues/1890#issuecomment-2367103614
    # NOTE: IF NOT STARTing: propably because '$XDG_STATE_HOME/steam-home' folder doesn't exist
    package = pkgs.steam.override {
      extraBwrapArgs = [
        "--bind $XDG_STATE_HOME/steam-home $HOME"

        # Will do more harm than good here
        "--unsetenv XDG_CACHE_HOME"
        "--unsetenv XDG_CONFIG_HOME"
        "--unsetenv XDG_DATA_HOME"
        "--unsetenv XDG_STATE_HOME"
      ];
    };
  };
}
