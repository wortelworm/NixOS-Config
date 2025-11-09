{
  config,
  lib,
  ...
}: {
  services.syncthing = lib.mkIf config.wortel.self-hosting.syncthing {
    enable = true;

    # Open up required ports for file synchronization,
    # but not for the GUI!
    # GUI runs by default on 8384.
    openDefaultPorts = true;

    settings = {
    };
  };
}
