{
  lib,
  pkgs,
  writeTextFile,
  ...
}:
writeTextFile {
  name = "Wortel battery fetcher";
  text = "#!${lib.getExe pkgs.nushell}\n" + (lib.readFile ./fetch-battery.nu);
  executable = true;
  destination = "/bin/fetch-battery";
}
