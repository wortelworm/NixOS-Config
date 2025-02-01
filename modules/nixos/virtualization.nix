{pkgs, ...}: {
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
  #   Visual studio installer: Select 'windows application environment', not '.NET desktop environment'
  #
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    qemu = {
      runAsRoot = false;
      vhostUserPackages = [pkgs.virtiofsd];
    };
  };

  # Used for building redox
  virtualisation.podman = {
    enable = true;
  };

  # Redirect local dns port to point at pi-hole
  # TODO: might want to recreate pihole myself?
  # systemd.services.wortel-dns-redirect = {
  #   enable = true;
  #   after = ["network.target"];
  #   wantedBy = ["default.target"];
  #   description = "Wortel dns port redirection";
  #   script = ''/run/current-system/sw/bin/iptables -t nat -A OUTPUT -d 127.0.0.1 -p udp --dport 53 -j REDIRECT --to-ports 5353'';
  # };
}
