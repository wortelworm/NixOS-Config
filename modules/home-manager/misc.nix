{
  pkgs,
  wortel,
  ...
}: {
  home.packages = with pkgs;
    lib.optionals wortel.gui [
      # TODO: figure out how to make blender use nvidia drivers
      # blender

      # remote desktop
      remmina
    ];
}
