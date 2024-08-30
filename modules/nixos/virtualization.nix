{ pkgs, ... }:

{
  # Notes on virt-manager:
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
  
  # Redirect local dns port to point at pi-hole
  systemd.user.services.wortel-dns-redirect = {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    description = "Wortel dns port redirection";
    serviceConfig = {
        Type = "simple";
        ExecStart = ''iptables -t nat -A OUTPUT -d 127.0.0.1 -p udp --dport 53 -j REDIRECT --to-ports 5353'';
    };
  };
}
