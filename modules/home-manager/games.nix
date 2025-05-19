{
  lib,
  pkgs,
  wortel,
  ...
}: {
  home.packages = lib.mkIf wortel.games (with pkgs; [
    prismlauncher
    airshipper

    # Steam is added under nixos, because it needs extra stuff
  ]);
}
