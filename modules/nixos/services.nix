{
  config,
  lib,
  pkgs,
  ...
}: {
  services.fprintd = lib.mkIf config.wortel.fingerprint {
    # to enroll, use kde's ui??
    # it is not working :(
    enable = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;

  hardware.bluetooth = {
    # This is handy, but I don't use it reguarly.
    enable = true;
    # Don't let my computers randomly connect on startup.
    powerOnBoot = false;
  };

  # Note: the adress of printer at home is:
  # http://192.168.178.25:80/WebServices/Device
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      mfc6890cdwlpr
      mfc5890cnlpr
    ];
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    ### other audio things if it doesnt work yet
    ### (jack is more modern than alsa I believe)
    # jack.enable = true;
    alsa.enable = true; # used by veloren
    # alsa.support32Bit = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
