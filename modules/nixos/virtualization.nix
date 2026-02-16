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
    qemu = {
      runAsRoot = false;
      vhostUserPackages = [pkgs.virtiofsd];
    };
  };

  # Gpu passthrough:
  #   See: https://github.com/bryansteiner/gpu-passthrough-tutorial/
  #   Also: https://olai.dev/blog/nvidia-vm-passthrough/
  #   Requires hardware support, I'll just assume I have that
  #   Checking groups in nushell:
  #     requires nix-shell -p pciutils
  #     ls /sys/kernel/iommu_groups/*/devices/* | each {|f| let p = $f.name | parse '/sys/kernel/iommu_groups/{i}/devices/{s}' | get 0; { group: ($p.i | into int), name: (lspci -nns $p.s) }} | sort
  #   Unable to start booting? A program (like btop or cosmic!) is using the graphics card, even though nvidia-smi says otherwise
  #   Note that something like looking glass is not possible, because there is no display output from the dGPU directly...
  #   Also right now I don't even need it
  # boot.kernelParams = [
  #   "amd_iommu=on"
  #   "iommu=pt"
  # ];

  virtualisation.libvirtd.hooks.qemu = let
    pci_video = "pci_0000_01_00_0";
  in {
    "hardware_isolation" = lib.getExe (pkgs.writeShellApplication {
      name = "hardware_isolation";
      # runtimeInputs = with pkgs; [
      #   # Required for virsh
      #   libvirt
      # ];
      text = ''
        function enable () {
          # ## Disable nvidia modules
          # modprobe -r nvidia_drm
          # modprobe -r nvidia_modeset
          # modprobe -r nvidia_uvm
          # modprobe -r nvidia

          # ## Load vfio
          # modprobe vfio
          # modprobe vfio_iommu_type1
          # modprobe vfio_pci

          # ## Unbind gpu from nvidia and bind to vfio
          # virsh nodedev-detach ${pci_video}

          ## Limit cores for host
          systemctl set-property --runtime -- user.slice AllowedCPUs=0,1,2,3
          systemctl set-property --runtime -- system.slice AllowedCPUs=0,1,2,3
          systemctl set-property --runtime -- init.scope AllowedCPUs=0,1,2,3
        }

        function disable () {
          ## Give host all cores back
          systemctl set-property --runtime -- init.scope AllowedCPUs=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
          systemctl set-property --runtime -- system.slice AllowedCPUs=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
          systemctl set-property --runtime -- user.slice AllowedCPUs=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15

          # ## Unbind gpu from vfio
          # virsh nodedev-reattach ${pci_video}

          # ## Unload vfio
          # modprobe -r vfio_pci
          # modprobe -r vfio_iommu_type1
          # modprobe -r vfio

          # ## Re-enable nvidia modules
          # modprobe nvidia
          # modprobe nvidia_uvm
          # modprobe nvidia_modeset
          # modprobe nvidia_drm
        }

        # GUEST_NAME="$1"
        HOOK_NAME="$2"
        STATE_NAME="$3"

        if [ "$HOOK_NAME" == "prepare" ] && [ "$STATE_NAME" == "begin" ]; then
          enable
        fi

        if [ "$HOOK_NAME" == "release" ] && [ "$STATE_NAME" == "end" ]; then
          disable
        fi
      '';
    });
  };

  # Used for building redox
  virtualisation.podman = {
    enable = true;
  };
  environment.systemPackages = [pkgs.podman-compose];
}
