{pkgs, ... }:

{
  # will be only non-home manager packages
  environment.systemPackages = with pkgs; [
    firefox
    libreoffice-qt # qt version because I'm using kde
    keepassxc
    bottles

    # utils
    vim
    zoxide
    tree
    nh
    gparted ntfs3g

    # funs
    neofetch
    cmatrix
  ];

  # one day I should make lutris manage steam
  programs.steam = {
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