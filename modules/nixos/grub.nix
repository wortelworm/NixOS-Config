{pkgs, ...}: {
  boot.loader = {
    timeout = 5;

    # From default configuration
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };

    # Grub is much nicer than systemd boot
    grub = {
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
    };
  };
}
