{ pkgs, ... }:

{
  home.packages = with pkgs; [
    obsidian
    onedrivegui
    thunderbird
    discord
    # todo: figure out how to use the
    # nvidia card with cycles
    blender

    # remote desktop
    remmina
  ];

}

