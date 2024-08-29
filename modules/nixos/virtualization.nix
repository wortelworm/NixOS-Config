{ pkgs, ... }:

{
  # See also: https://wiki.nixos.org/wiki/Virt-manager
  # Try to make windows vm
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    qemu = {
      runAsRoot = false;
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };


  # Used to test pihole
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };

    # Daemon settings?
  };
}
