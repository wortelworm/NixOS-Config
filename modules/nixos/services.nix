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
    # Note that loglevel can be configured in the ui in http://localhost:631
    # The log is written to the system log thing
    drivers = with pkgs; [
      mfc6890cdwcupswrapper
    ];
  };
  networking.hosts = {
    # Fix the driver being unable to communicate
    # TODO: figure out a way of setting hostname to hostname
    # instead of hostname to ip
    # "BRN001BA953AEED.fritz.box" = ["BRN001BA953AEED.local"];
    "192.168.178.25" = ["BRN001BA953AEED.local"];
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pulseaudio.enable = false;
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
