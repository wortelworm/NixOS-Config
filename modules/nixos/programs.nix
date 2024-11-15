{
  config,
  lib,
  pkgs,
  ...
}: {
  # will be only non-home manager packages
  environment.systemPackages = with pkgs; [
    firefox
    libreoffice-qt # qt version because I'm using kde
    keepassxc
    bottles
    alacritty

    # utils
    vim
    zoxide # Database location: ~/.local/share/zoxide/
    tree
    nh
    dust
    btop
    bat

    # disk partitions
    gparted
    ntfs3g

    # funs
    fastfetch
    cmatrix
    cbonsai
    cava

    # Note: nix-inspect is a tool that may prove useful
  ];

  # font, used automaticly by kitty
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["Hack"];})
  ];

  # Could be cool to use in like 2028
  # programs.ladybird.enable = true;

  # it has to be installed system wide...
  programs.steam = lib.mkIf config.wortel.games {
    enable = true;
    # Open ports in the firewall for Steam Remote Play
    remotePlay.openFirewall = false;
    # Open ports in the firewall for Source Dedicated Server
    dedicatedServer.openFirewall = false;
  };

  # A lot of software is disabled by default,
  # I currently do not care that much about things being unfree
  nixpkgs.config.allowUnfree = true;
}
