{ lib, pkgs, wortel, ... }:

{
  home.packages = lib.mkIf wortel.games (with pkgs; [
    prismlauncher
    airshipper # plasma 6 breaks the ui...

    jdk21_headless # minecraft server uses this

    # lutris
    # wineWowPackages.waylandFull
    # wineWowPackages.full
  ]);
}