{
  lib,
  pkgs,
  ...
}: {
  # For future me, if you messed up everything like just now:
  #     Boot from an usb stick (press escape during pre-boot)
  #     Use `sudo mount /dev/nvme0n1p6 /mnt` and then `sudo nixos-enter`
  #     check that /var/lib/nixos/gid-map and /var/lib/nixos/uid-map are valid json
  #     If home-manager fails, check journalctl for error messages
  #     A bunch of files may be corrupted
  #

  # Notes on virt-manager:
  #   If getting a triple fault: remove '/dev/' from the pool thing from /var/lib/libvirt/storage/
  #   see also: https://wiki.nixos.org/wiki/Virt-manager
  #   Enable more graphs: preferences -> polling
  #   Fix screen: view -> scale display -> autoresize vm to window
  #   Guest only using 1 cpu core: change cpu topology to one socket, more of the other stuff
  #   Screen tearing: use video QXL instead of virtio
  #
  # Notes for windows vm:
  #   Install winfsp and virtio-win-guest-tools on guest for folder sharing
  #   Also install the second one for changing the resolution (automatically)
  #   Display spice with OpenGL doesn't work on windows guest
  #   Visual studio installer: Select 'windows application environment', not '.NET desktop environment'
  #
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    qemu = {
      runAsRoot = false;
      vhostUserPackages = [pkgs.virtiofsd];
      # Note some examples also include:
      # ovmf.enable = true;
    };
  };

  # Gpu passthrough:
  #   See: https://github.com/bryansteiner/gpu-passthrough-tutorial/
  #   Alos: https://olai.dev/blog/nvidia-vm-passthrough/
  #   Requires hardware support, I'll just assume I have that
  #   Also this method requires two gpus? And an additional display is handy
  #   Checking groups in nushell:
  #     requires nix-shell -p pciutils
  #     ls /sys/kernel/iommu_groups/*/devices/* | each {|f| let p = $f.name | parse '/sys/kernel/iommu_groups/{i}/devices/{s}' | get 0; { group: ($p.i | into int), name: (lspci -nns $p.s) }} | sort

  # Eventual TODO: using hooks so that this is not just a specialization but can be changed while booted
  # First bind the devices to VFIO
  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
    "vfio-pci.ids=${lib.concatStringsSep "," [
      # Nvidia 3050 Mobile on wortelworm5
      "14c3:7961"
    ]}"
  ];
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  # Blacklist the nvidia drivers to make sure they don't get loaded
  boot.extraModprobeConfig = ''
    softdep nvidia pre: vfio-pci
    softdep drm pre: vfio-pci
    softdep nouveau pre: vfio-pci
  '';
  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
    "i2c_nvidia_gpu"
  ];

  # Used for building redox
  virtualisation.podman = {
    enable = true;
  };

  # Redirect local dns port to point at pi-hole
  # TODO: might want to recreate pihole myself?
  # Use 'netstat -nlp' to see open connections
  # systemd.services.wortel-dns-redirect = {
  #   enable = true;
  #   after = ["network.target"];
  #   wantedBy = ["default.target"];
  #   description = "Wortel dns port redirection";
  #   script = ''/run/current-system/sw/bin/iptables -t nat -A OUTPUT -d 127.0.0.1 -p udp --dport 53 -j REDIRECT --to-ports 5353'';
  # };
}
