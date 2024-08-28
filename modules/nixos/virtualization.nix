{ ... }:

{
  virtualisation = {
    # Should try to do qemu with gpu passthrough for windows one day


    # Want to set up pi-hole with this
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };

      # Daemon settings?
    };
  };
}
