{ pkgs, ... }:

{
  # Bootloader.
  boot.loader = {
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

    # Part of 'Silent boot'
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    timeout = 0;
  };

  # Display eye candy while computer is starting
  boot = {
    plymouth = {
      enable = true;
      theme = "infinite_seal";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "infinite_seal" ];
        })
      ];
    };

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
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
