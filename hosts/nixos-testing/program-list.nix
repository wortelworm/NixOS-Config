{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
      firefox
      kate
      keepassxc
      obsidian
      onedrivegui
      prismlauncher
      rustup
      thunderbird
      vim

      neofetch
      tree

      discord
      # steam
    ];

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

    # currently required as obsidian uses outdated version of electron
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];
}

