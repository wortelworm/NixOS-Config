{
  description = "Nixos config flake";

  inputs = {
    # This is to make sure that the cosmic cache is working properly
    # Can be replaced once cosmic is in the main nixpkgs branch.
    nixos.follows = "nixos-cosmic/nixpkgs-stable";

    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixos";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
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
      url = "github:kmonad/kmonad?submodules=1&dir=nix";
      inputs.nixpkgs.follows = "nixos";
    };

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
        substituters = ["https://cosmic.cachix.org/"];
        trusted-public-keys = ["cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="];
      };
    };

    pkgs-unstable = import inputs.nixos-unstable {inherit system;};

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
