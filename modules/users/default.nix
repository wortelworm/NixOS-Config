{ config, ... }:

{
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
    extraSpecialArgs = { inherit (config) wortel; };
    users = {
      "wortelworm" = import ./home.nix;
    };
  };
}