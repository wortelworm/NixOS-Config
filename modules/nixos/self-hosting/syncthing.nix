{
  config,
  lib,
  ...
}: {
  services.syncthing = lib.mkIf config.wortel.self-hosting.syncthing {
    enable = true;

    # To make it easy to sync my personal documents
    user = "wortelworm";
    group = "users";
    dataDir = "/home/wortelworm";
    # note that the config dir should be overwritten if using non-default xdg folders

    # Open up required ports for file synchronization,
    # but not for the GUI!
    # GUI runs by default on 8384.
    openDefaultPorts = true;

    # Settings & password configured via the UI for now
  };
}
