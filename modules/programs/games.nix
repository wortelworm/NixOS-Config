{ pkgs, ... }:

{
  home.packages = with pkgs; [
    prismlauncher
  ];

  # steam is always installed currently...
}