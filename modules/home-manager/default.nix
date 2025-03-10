{
  config,
  inputs,
  pkgs-unstable,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wortelworm = {
    isNormalUser = true;
    description = "Wortel Worm";
    extraGroups = [
      # Podman replaced docker
      "podman"

      # Used for kmonad
      "input"
      "uinput"

      # Used by virt-manager
      "libvirtd"

      # Used by arduino, for the usb port
      "dialout"

      # idk what these do
      "networkmanager"
      "wheel"
    ];
  };

  home-manager = {
    # also pass inputs to home-manager modules?
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit (config) wortel;
      inherit inputs;
      inherit pkgs-unstable;
    };
    users = {
      "wortelworm" = import ./home.nix;
    };
  };
}
