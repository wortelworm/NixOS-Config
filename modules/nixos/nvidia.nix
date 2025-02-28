{
  config,
  lib,
  ...
}: {
  # see: https://wiki.nixos.org/wiki/NVIDIA
  # THIS IS MADE SPECIFICLY FOR WORTELWORM5
  # 
  # TODO: why does creating an assertion create infinite loop?
  config = lib.mkIf config.wortel.nvidia {

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware.graphics.enable = true;
    hardware.nvidia = {
      # Fixed some kernel panics for me
      open = true;

      prime = {
        # offload is better for battery than sync, so I will use this for now
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        # use command line tool `nix shell nixpkgs#pciutils -c lspci -d ::03xx` to find out these addresses
        # make sure to convert them to correct format and decimal!
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:4:0:0";
      };

      # What could I even use this for?
      nvidiaSettings = false;
    };
  };
}
