# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{inputs, ...}: {
  networking.hostName = "nixos-testing";

  imports = [
    ./hardware-configuration.nix
    ../../modules

    inputs.home-manager.nixosModules.default
  ];

  wortel = {
    games = true;
  };

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
