{pkgs, ...}: {
  boot = {
    # From default configuration
    loader.efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };

    # Grub is much nicer than systemd boot
    loader.grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      # boot into last os used
      default = "saved";

      # I want a specific subdirectory from the github
      # Using mkDerivation to prevent the entire repo to be used
      theme = pkgs.stdenv.mkDerivation rec {
        name = "HyperFluent-GRUB-Theme";
        src = pkgs.fetchFromGitHub {
          owner = "Coopydood";
          repo = name;
          rev = "3268a7cf8f7351539e7a5d30904a6fa14767bae8";
          hash = "sha256-0SzFM4r8Mo+vaGPeTQgZcAWrqgseKKmEC6xjRDTvDoQ=";
        };
        installPhase = "cp -r nixos $out";
      };

      # Notes on using grub:
      # You can enable the pager using `set pager=1`
      # Then you can use `ls` and `cat`
      # The boot partition is probably: `ls (hd0,1)/`
    };

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;

    plymouth = {
      enable = true;
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };
}
