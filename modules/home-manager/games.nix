{
  lib,
  pkgs,
  wortel,
  ...
}: {
  home.packages = lib.mkIf wortel.games (with pkgs; [
    prismlauncher
    airshipper # plasma 6 breaks the ui...

    jdk21_headless # minecraft server uses this

    # Steam is added under nixos, because it needs extra stuff
  ]);
}
