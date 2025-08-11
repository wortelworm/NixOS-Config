{
  config,
  lib,
  pkgs,
  ...
}: let
  immich-enabled = config.wortel.self-hosting.immich;
  services = [
    "immich-server"
    "redis-immich"
    # NOTE: if using postgress for anything else, then might want to remove this
    "postgresql"
  ];
in {
  services.immich = lib.mkIf immich-enabled {
    enable = true;
    port = 2283;

    # Listen everywhere, allow other devices to access this service
    host = "0.0.0.0";
    openFirewall = true;

    # Disabling any additional features for now, to try it out
    # if re-enabling this, must also add it to the services variable up above
    machine-learning.enable = false;

    settings = {
      # Actually informing immich that machine learning is disabled
      machineLearning.enabled = false;

      storageTemplate = {
        enabled = true;
        template = "{{y}}/{{MM}}/{{filename}}";
      };

      # Altough it updates every once in a while automatically, I would like to know whenever new versions come around
      newVersionCheck.enabled = true;

      # TODO: Any more settings/...??
    };

    # Note that users are set up using the UI.
  };

  # Disable autostart, add command line utilty for starting/stopping
  systemd.services = builtins.listToAttrs (
    builtins.map (name: {
      name = name;
      value.wantedBy = lib.mkForce [];
    })
    services
  );

  environment.systemPackages = lib.optionals immich-enabled [
    (
      pkgs.writeScriptBin "immich-manager"
      ''
        #!${lib.getExe pkgs.nushell}

        let services = ["${lib.strings.concatStringsSep "\", \"" services}"];

        def main [] {
          help main
        }

        # Enable all systemd immich services
        def "main enable" [] {
          $services | each {|service|
            sudo systemctl start $service
          };
        }

        # Disable all systemd immich services
        def "main disable" [] {
          $services | each {|service|
            sudo systemctl stop $service
          };
        }
      ''
    )
  ];
}
