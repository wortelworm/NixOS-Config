{lib, ...}:
# This module uses a hack to provide grub with descriptions of generations.
let
  label_exists = builtins.pathExists ../nixos-label.txt;
in {
  system.nixos.label = lib.mkIf label_exists (
    lib.strings.trim (builtins.readFile ../nixos-label.txt)
  );

  warnings = lib.mkIf (!label_exists) [
    "Unable to read commit message"
  ];
}
