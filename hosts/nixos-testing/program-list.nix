{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
      firefox
      # git
      kate
      keepassxc
      obsidian
      onedrivegui
      prismlauncher
      rustup
      thunderbird
      vim
      vscodium

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

    # idk how to configure this properly, but something like this is required to run minecraft
#     environment.sessionVariables = {
#         LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
#     };
#    hardware.opengl = {
#      enable = true;
#      driSupport = true;
#      driSupport32Bit = true;
#      setLdLibraryPath = true;
#    };
}

