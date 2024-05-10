{ pkgs, ... }:

{
  home.packages = with pkgs; [
    prismlauncher
    lutris
    wineWowPackages.waylandFull
    # wineWowPackages.full
    airshipper # plasma 6 breaks the ui...
  ];
}