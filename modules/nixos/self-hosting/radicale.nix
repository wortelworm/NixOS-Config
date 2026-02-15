{
  config,
  pkgs,
  lib,
  ...
}: {
  # Allow syncthing to synchronize the contacts.
  # Syncthing now runs as the 'wortelworm' user, so add group to that one.
  # Also give group write permissions
  users.users.wortelworm.extraGroups = ["radicale"];
  systemd.services.radicale.serviceConfig.StateDirectoryMode = lib.mkForce "0770";
  systemd.services.radicale.serviceConfig.UMask = lib.mkForce "0007";

  # Default port: 5232
  services.radicale = lib.mkIf config.wortel.self-hosting.radicale {
    enable = true;
    settings = {
      # TODO's

      auth = {
        # Use the `htpasswd` cli from apache to generate the password.
        type = "htpasswd";
        htpasswd_filename = "${pkgs.writeText "radicale-passwords" ''
          wortel:$2y$12$dERiA8ILqaqiu1nAtI1xc.lhD70The8JzCdg2jWC8gUKCCtLxwYKi
        ''}";
      };
    };
  };
}
