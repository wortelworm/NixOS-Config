{
  description = "Nixos config flake";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-24.05";

    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixos";
    };

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixos";
    };
    
    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixos";
    };

    kmonad = {
      # url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
      url = "github:kmonad/kmonad?submodules=1&dir=nix";
      inputs.nixpkgs.follows = "nixos";
    };

    # see modules/home-manager/plasma-home.nix
    # plasma-manager = {
    #   url = "github:pjones/plasma-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    # };
  };

  outputs = { self, nixos, ... }@inputs: {
    nixosConfigurations =
    builtins.listToAttrs (
      builtins.map (hostname: {
        name = hostname;
        value = nixos.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            # note: the order might matter
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
              };
            }

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
