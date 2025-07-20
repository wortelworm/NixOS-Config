{
  config,
  lib,
  pkgs,
  wortel,
  ...
}: {
  config = lib.mkIf wortel.onedrive {
    # Do manual sync using `onedrive --sync --confdir="~/.config/.."`
    # Start continual sync using `onedrive --monitor --confdir=..`
    home.packages = with pkgs; [
      onedrive
      (writeShellScriptBin "s" ''
        onedrive --confdir="${config.xdg.configHome}/onedrive/personal" --sync
        onedrive --confdir="${config.xdg.configHome}/onedrive/uni" --sync
      '')
    ];

    xdg.configFile = let
      generateConfig = lib.generators.toKeyValue {
        mkKeyValue = name: value: ''${name} = "${value}"'';
      };
    in {
      "onedrive/uni/config".text = generateConfig {
        sync_dir = "~/Onedrive-uni";
      };
      "onedrive/personal/config".text = generateConfig {
        sync_dir = "~/Onedrive-personal";
      };
    };
  };
}
