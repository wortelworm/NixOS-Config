{ pkgs, ... }:

{
  home.packages = with pkgs; [
    prismlauncher
    lutris
    wineWowPackages.waylandFull
    # wineWowPackages.full
    airshipper # plasma 6 breaks the ui...

    jdk21_headless # minecraft server uses this
  ];
}