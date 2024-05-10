{ pkgs, ... }:

{
  home.packages = with pkgs; [
    obsidian
    onedrivegui
    thunderbird
    discord
    # todo: figure out how to make blender use nvidia drivers
    blender

    # remote desktop
    remmina
  ];

}

