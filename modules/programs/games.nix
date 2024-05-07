{ pkgs, ... }:

{
  home.packages = with pkgs; [
    prismlauncher
    lutris
    airshipper # plasma 6 breaks the ui...
  ];
}