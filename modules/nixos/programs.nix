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

  # will be only non-home manager programs in path
  environment.systemPackages = with pkgs; [
    firefox
    libreoffice-qt # qt version because I'm using kde
    keepassxc
    alacritty

    # utils
    tree
    nh
    dust
    btop
    bat
    lazygit
    nix-inspect
    ripgrep
    netscanner
    tokei
    just
    fetch-battery

    # disk partitions
    gparted
    ntfs3g
  ];

  # font, used automaticly by kitty
  # I want to have support for nerdfonts and ligatures
  #     Hack: does not have ligatures
  #     FiraCode: weird g
  #     JetBrainsMono:
  #         Text is more vertical space,
  #         bad for things like btop
  #         in kitty it is fine, int alacritty its worse
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Starts OpenSSH agent on login, so don't have to type
  # passphrase on every git push (ssh connection)
  programs.ssh.startAgent = true;

  programs.kdeconnect.enable = true;

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
