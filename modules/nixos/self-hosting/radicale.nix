{
  config,
  lib,
  ...
}: {
  services.radicale = lib.mkIf config.wortel.self-hosting.radicale {
    enable = true;
    settings = {
      # TODO's
      auth.type = "none";
    };
  };
}
