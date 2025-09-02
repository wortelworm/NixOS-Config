{
  inputs,
  lib,
  pkgs,
  ...
}: {
  # For terminal access, run:
  # $env.QEMU_KERNEL_PARAMS = 'console=ttyS0'; nix run path:.#nixosConfigurations.vm-testing.config.system.build.vm -- -nographic
  #
  # For graphical access, run:
  # nix run path:.#nixosConfigurations.vm-testing.config.system.build.vm
  #
  # These commands should be getting included in the justfile...

  # The qemu vm module creating the `config.system.build.vm` can be found here:
  # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/virtualisation/qemu-vm.nix

  # Can test now:
  #   full configuration
  #   disko, impermanence, luks, btrfs
  #   different boot loaders

  # Here testing different boot loaders
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.grub = {
  #   enable = true;
  #   efiSupport = true;
  #   extraFiles."nixos-generations.txt" = pkgs.writeTextFile {
  #     name = "nixos-generations.txt";
  #     text = ''
  #       Here is a test. Can you see this from grub??

  #       237 - d48da9985 (dirty) - Zed rust debugging and typst support
  #       236 - 0bfcea39d - Kanata added keys and reduced delay
  #       235 - 93d2ab6a8 - Immich disabled autostart
  #     '';
  #   };
  # };
  # boot.loader.limine = {
  #   enable = true;
  #   style = {
  #     wallpapers = [];
  #   };
  #   # efiSupport = true;
  #   # additionalFiles."nixos-generations.txt" = pkgs.writeTextFile {
  # };

  imports = [
    # inputs.disko.nixosModules.disko
    # ../../modules/nixos/grub.nix
    # ../../modules/nixos/localization.nix
    ../../modules
  ];

  # home-manager.users.wortelworm = {
  #   programs.bash.enable = lib.mkForce false;
  #   systemd.user.sessionVariables = {
  #     AAAAAAAAAAAAAAAAAA = "testing123";
  #   };
  # };

  wortel = {
    hostname = "vm-testing";
    xdgAlternative = true;
    textEditors.helix.enable = true;
  };

  users.users.wortelworm = {
    initialPassword = "test";
  };

  # environment.systemPackages = with pkgs; [
  #   cowsay
  #   lolcat
  #   btop
  #   yazi
  #   nushell
  # ];

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Cosmic desktop & login screen
  # services.displayManager.cosmic-greeter.enable = true;
  # services.desktopManager.cosmic.enable = true;

  # KDE greeter and desktop
  # services.displayManager.sddm = {
  #   enable = true;
  # };
  # services.desktopManager.plasma6.enable = true;

  # disko.tests.efi = true;
  # disko.devices.disk.main = {
  #   type = "disk";
  #   imageSize = "16G";
  #   content.type = "gpt";
  #   content.partitions = {
  #     ESP = {
  #       size = "256M";
  #       type = "EF00";
  #       content = {
  #         type = "filesystem";
  #         format = "vfat";
  #         mountpoint = "/boot";
  #         mountOptions = ["umask=0077"];
  #       };
  #     };
  #     root = {
  #       size = "100%";
  #       content = {
  #         type = "filesystem";
  #         format = "btrfs";
  #         mountpoint = "/";
  #       };
  #     };
  #     plainSwap = {
  #       size = "4G";
  #       content = {
  #         type = "swap";
  #         discardPolicy = "both";
  #         resumeDevice = true; # resume from hiberation from this device
  #       };
  #     };
  #   };
  # };

  # Let qemu give the vm some extra resources
  virtualisation = let
    cfg = {
      virtualisation = {
        cores = 8;
        memorySize = 4000;

        useEFIBoot = true;
      };
    };
  in {
    vmVariant = cfg;
    vmVariantWithBootLoader = cfg;
    # vmVariantWithDisko = cfg;
  };

  system.stateVersion = "25.05";
}
