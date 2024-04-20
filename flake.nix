{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # plasma-manager = {
    #   url = "github:pjones/plasma-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    # };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {

      nixos-testing = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/nixos-testing/configuration.nix

          inputs.home-manager.nixosModules.default
        ];
      };

      wortelworm5 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/wortelworm5/configuration.nix

          inputs.home-manager.nixosModules.default
        ];
      };
      
    };
  };
}
