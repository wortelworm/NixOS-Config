{
  config,
  lib,
  ...
}: {
  services.immich = lib.mkIf config.wortel.self-hosting.immich {
    enable = true;
    port = 2283;

    # Listen everywhere, allow other devices to access this service
    host = "0.0.0.0";
    openFirewall = true;

    # Disabling any additional features for now, to try it out
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
}
