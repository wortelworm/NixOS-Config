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
  #   Also install the second one for changing the resolution,
  #     or maybe spice guest tools? ( https://www.spice-space.org/download.html )
  #     also do I need looking glass?
  #     currently have all of these installed
  #   Display spice with OpenGL doesn't work on windows guest
  #   Virtio networking requires the guest tools to work
  #   Visual studio installer: Select 'windows application environment', not '.NET desktop environment'
  #
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    shutdownTimeout = 20;
    qemu = {
      runAsRoot = false;
      vhostUserPackages = [pkgs.virtiofsd];
    };
  };

  environment.systemPackages = [pkgs.podman-compose];
  virtualisation.podman = {
    enable = true;
  };

  # Enable waydroid, but don't start the container automatically on every boot.
  # Notes on usage:
  # See https://wiki.nixos.org/wiki/Waydroid, mostly running `sudo waydroid init` on first boot.
  # Also https://docs.waydro.id/faq/disable-on-screen-keyboard is nice.
  systemd.services.waydroid-container.wantedBy = lib.mkForce [];
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
}
