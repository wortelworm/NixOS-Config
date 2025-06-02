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

  services.homepage-dashboard = {
    enable = true;
    listenPort = 5000;

    settings = {
      title = "Wortel's home services";

      background = {
        image = "https://raw.githubusercontent.com/wortelworm/NixOS-Config/refs/heads/main/resources/wallpaper.png";
        blur = "xl";
      };
    };

    services = [
      {
        "Localhost" = [
          {
            "AdGuard Home" = {
              href = "http://localhost:5001/";
              description = "Ad, malware and trackers blocker using DNS";
              icon = "https://st.agrd.eu/favicons/adguard/favicon.svg";
              widget = {
                type = "adguard";
                url = "http://localhost:5001/";
              };
            };
          }
          {
            "Cups" = {
              href = "http://localhost:631/";
              description = "Printer controller";
            };
          }
        ];
      }
      {
        "External hosts" = [
          {
            "P1mon" = {
              href = "http://p1mon/";
              description = "Smart electricity reader";
            };
          }
          {
            "Heatpump" = {
              href = "http://192.168.178.21/";
              description = "Siemens heatpump controller";
            };
          }
        ];
      }
    ];
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
  networking = {
    hosts = {
      # Fix the driver being unable to communicate
      # TODO: figure out a way of setting hostname to hostname
      # instead of hostname to ip
      # "BRN001BA953AEED.fritz.box" = ["BRN001BA953AEED.local"];
      "192.168.178.25" = ["BRN001BA953AEED.local"];
    };

    # Use local dns server
    nameservers = ["127.0.0.1:53"];
  };

  # Block malware, ads, trackers and such
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    host = "127.0.0.1";
    port = 5001;
    settings = {
      dns = {
        bind_hosts = ["127.0.0.1"];
        port = 53;

        bootstrap_dns = ["1.1.1.1"];
        upstream_dns = ["https://1.1.1.1/dns-query" "https://1.0.0.1/dns-query"];
      };

      # TODO: block *.fritz.box for improved speeds?

      # For example, https://googlesyndication.com/ should be blocked
      filters =
        map (url: {
          enabled = true;
          url = url;
        }) [
          "https://big.oisd.nl"
          "https://nsfw.oisd.nl"
        ];
    };
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
