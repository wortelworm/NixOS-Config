# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, ... }:

{
  networking.hostName = "wortelworm5";

  wortel = {
    fingerprint = true;
    nvdia = true;
  };

  imports = [
    ./hardware-configuration.nix
    ../../modules

    inputs.home-manager.nixosModules.default
  ];

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

      splashImage = ../../resources/wallpaper.png;
      font = ../../resources/font.ttf;
      fontSize = 32;
    };
  };
  
  # This is only here for dualbooting with windows
  time.hardwareClockInLocalTime = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # version of default settings to use
  # CHECK RELEASE NOTES IF UPDATING
  system.stateVersion = "23.11"; # Did you read the comment?
}
