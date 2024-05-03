{pkgs, ... }:

{
  # will be only non-home manager packages
  environment.systemPackages = with pkgs; [
    firefox
    libreoffice-qt # qt version because I'm using kde
    keepassxc

    # command line utils
    vim
    zoxide
    tree
    nh

    # funs
    neofetch
    cmatrix
  ];

  # steam can only be installed globally...
  # idk how to make this toggable inside home-manager (yet)
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

  # currently required as obsidian uses outdated version of electron :(
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];
}