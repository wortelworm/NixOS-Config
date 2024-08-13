{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # see modules/nixos/desktop.nix
    # nixos-cosmic = {
    #   url = "github:lilyinstarlight/nixos-cosmic";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # see modules/home-manager/plasma-home.nix
    # plasma-manager = {
    #   url = "github:pjones/plasma-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    # };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = builtins.listToAttrs (
      builtins.map (hostname: {
        name = hostname;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            # note: the order might matter
            # {
            #   nix.settings = {
            #     substituters = [ "https://cosmic.cachix.org/" ];
            #     trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            #   };
            # }
            # inputs.nixos-cosmic.nixosModules.default

            inputs.home-manager.nixosModules.default
            inputs.grub2-themes.nixosModules.default

            ./hosts/${hostname}/configuration.nix
          ];
        };
      }) [
        "wortelworm5"
        "nixos-testing"
      ]
    );
  };
}
