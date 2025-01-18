{
  config,
  lib,
  pkgs,
  ...
}: {
  # Notes on programs not added:
  #     termscp: filezilla in the terminal
  #     browsh: browser in terminal, may be a lifesaver in a weird senario
  #     bottles: running windows programs
  #         But does not work for microsoft visual studio and microsoft office
  #     ripgrep-all: like ripgrep but many more file formats
  #         adds ~225MiB of dependencies for something I almost never gonna use

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

    # disk partitions
    gparted
    ntfs3g

    # funs
    asciiquarium-transparent
    fastfetch
    cmatrix
    cbonsai
    cava
  ];

  # font, used automaticly by kitty
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Hack"];})
  ];

  # Starts OpenSSH agent on login, so don't have to type
  # passphrase on every git push (ssh connection)
  programs.ssh.startAgent = true;

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
