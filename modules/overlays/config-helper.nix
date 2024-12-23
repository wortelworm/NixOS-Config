{
  lib,
  writeTextFile,
  ...
}:
# This has dependencies on 'nushell' and 'nh',
# But idk how to do that in a nice way
writeTextFile {
  name = "Wortel config helper";
  text = lib.readFile ./config-helper.nu;
  executable = true;
  destination = "/bin/n";
}
