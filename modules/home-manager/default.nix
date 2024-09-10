{ config, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wortelworm = {
    isNormalUser = true;
    description = "Wortel Worm";
    extraGroups = [
      # Allows me to use docker without sudo
      # Docker is being run in rootless mode, so it should be fine
      "docker"

      # Used for kmonad
      "input" "uinput"

      # Used by virt-manager
      "libvirtd"

      # idk what these do
      "networkmanager" "wheel"
    ];
  };

  home-manager = {
    # also pass inputs to home-manager modules?
    useGlobalPkgs = true;
    useUserPackages = true;
    # sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
    extraSpecialArgs = { inherit (config) wortel; inherit inputs; };
    users = {
      "wortelworm" = import ./home.nix;
    };
  };
}
