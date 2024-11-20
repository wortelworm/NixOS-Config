{
  lib,
  pkgs,
  wortel,
  ...
}: {
  home.packages = lib.mkIf wortel.games (with pkgs; [
    prismlauncher
    # plasma 6 breaks the ui...
    # Idk but on cosmic does work
    airshipper

    # Steam is added under nixos, because it needs extra stuff
  ]);
}
