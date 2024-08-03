{ pkgs, ... }:

{
  # Bootloader.
  boot.loader = {
    timeout = 5;

    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      device = "nodev";
      useOSProber = true;
      efiSupport = true;
      # boot into last os used
      default = "saved";
    };

    grub2-theme = {
      enable = true;
      theme = "vimix";
      icon = "color";
      screen = "4k";
    };
  };

  # minegrub, here to stay as an example
  # boot.loader.grub.theme = pkgs.stdenv.mkDerivation rec {
  #   name = "minegrub-world-sel-theme";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "Lxtharia";
  #     repo = "${name}";
  #     rev = "9db8c052dc";
  #     hash = "sha256-uhTUsI9bRr/TWQL9BqWT4OB74isQjVJdHvpgW/w4ayE=";
  #   };
  #   installPhase = "cp -r minegrub-world-selection $out";
  # };
}
