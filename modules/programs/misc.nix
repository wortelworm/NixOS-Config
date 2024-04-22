{ pkgs, ... }:

{
  home.packages = with pkgs; [
    obsidian
    onedrivegui
    thunderbird
    discord

    # remote desktop
    remmina
  ];

}

