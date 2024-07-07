{ pkgs, ... }:

{
  home.packages = with pkgs; [
    obsidian
    onedrivegui
    thunderbird
    vlc

    # to prevent the initial grey screen on login,
    # I dont know how, and now it is not even starting
    # should really look into an alternative discord client
    # something like abaddon maybe?
    discord
    # todo: figure out how to make blender use nvidia drivers
    blender

    # remote desktop
    remmina
  ];

}

