{
  lib,
  pkgs,
  pkgs-unstable,
  wortel,
  ...
}: {
  home.packages = lib.mkIf wortel.games (with pkgs; [
    prismlauncher
    pkgs-unstable.airshipper

    # Steam is added under nixos, because it needs extra stuff
  ]);
}
