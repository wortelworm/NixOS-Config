{ config, inputs, ... }:

{
  imports = [
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wortelworm = {
    isNormalUser = true;
    description = "Wortel Worm";
    extraGroups = [ "networkmanager" "wheel" ];
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