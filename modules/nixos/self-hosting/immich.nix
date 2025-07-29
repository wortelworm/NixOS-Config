{
  config,
  lib,
  ...
}: {
  services.immich = lib.mkIf config.wortel.self-hosting.immich {
    enable = true;
    port = 2283;
    openFirewall = true;

    # Disabling any additional features for now, to try it out
    machine-learning.enable = false;

    # openFirewall = true;
    # Any more settings/users/...??
  };
}
