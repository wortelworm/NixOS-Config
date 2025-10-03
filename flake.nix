{
  description = "Nixos config flake";

  inputs = {
    nixos.url = "github:nixos/nixpkgs/nixos-unstable";

    # nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixos";
    };

    nixvim = {
      url = "github:nix-community/nixvim/main";
      inputs.nixpkgs.follows = "nixos";
    };

    # Could try again in the future, not right now
    # zen-browser = {
    #   url = "github:0xc000022070/zen-browser-flake";
    #   inputs.nixpkgs.follows = "nixos";
    # };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixos";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {nixos, ...} @ inputs: let
    system = "x86_64-linux";
    hosts = [
      "wortelworm5"
      "nixos-testing"
    ];

    additionalCache = {
      nix.settings = {
        # Note: the nix-community cache does not contain nvidia-x11 package...
      };
    };

    # pkgs-unstable = import inputs.nixos-unstable {inherit system;};
    pkgs-unstable = import inputs.nixos {inherit system;};

    hostToSystem = hostname: {
      name = hostname;
      value = nixos.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs pkgs-unstable;
        };
        modules = [
          # note: the order might matter
          additionalCache

          ./hosts/${hostname}/configuration.nix
        ];
      };
    };
  in {
    nixosConfigurations = builtins.listToAttrs (
      builtins.map hostToSystem hosts
    );
  };
}
