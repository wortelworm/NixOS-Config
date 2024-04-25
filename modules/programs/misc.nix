{ pkgs, ... }:

{
  home.packages = with pkgs; [
    obsidian
    onedrivegui
    thunderbird
    discord
    # blender has to be build locally because
    # of the override, but during this build
    # everything for some reason freezes...
    # (blender.override {
    #   cudaSupport = true;
    # })

    # remote desktop
    remmina
  ];

}

