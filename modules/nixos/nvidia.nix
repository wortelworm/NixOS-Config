{
  config,
  lib,
  ...
}: {
  # see: https://nixos.wiki/wiki/Nvidia
  # THIS IS MADE SPECIFICLY FOR WORTELWORM5
  config = lib.mkIf config.wortel.nvidia {
    # has been renamed to hardware.graphics?
    # TODO
    # hardware.opengl = {
    #   enable = true;
    #   driSupport = true;
    #   driSupport32Bit = true;
    # };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      prime = {
        # use command line tool `sudo lshw -c display` to find out these addresses
        # make sure to convert them to correct format and decimal!
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:4:0:0";

        # offload is better for battery than sync, so I will use this for now
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };

      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
