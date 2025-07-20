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
    enable = false;
    listenPort = 5000;

    # Provide a background image to the package, TODO: this is not yet working...
    # package = pkgs.symlinkJoin {
    #   name = "homepage-dashboard-patched";
    #   paths = [
    #     pkgs.homepage-dashboard
    #   ];
    #   postBuild = ''
    #     # mkdir -p $out/share/homepage/public/
    #     ln -s ${../../resources/wallpaper.png} $out/share/homepage/public/background.png
    #   '';
    #   meta.mainProgram = pkgs.homepage-dashboard.meta.mainProgram;
    # };

    settings = {
      title = "Wortel's home services";

      background = {
        # TODO: use local content, its not yet working
        image = "https://raw.githubusercontent.com/wortelworm/NixOS-Config/refs/heads/main/resources/wallpaper.png";
        # image = "/background.png";
        blur = "xl";
      };
    };

    # TODO:
    # calendar

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
              href = "http://pol648/";
              description = "Siemens heatpump controller";
            };
          }
          {
            "Router" = {
              href = "http://fritz.box/";
              description = "Local fritz box";
            };
          }
        ];
      }
    ];

    widgets = [
      {
        "datetime" = {
          locale = "nl";
          format = {
            dateStyle = "short";
            timeStyle = "short";
          };
        };
      }
      {
        "openmeteo" = {
          latitude = 52.0907006;
          longitude = 5.1215634;
          cache = 5;
          units = "metric";
        };
      }
      {
        "resources" = {
          cpu = true;
          memory = true;
          disk = "/";
          cputemp = true;
          uptime = true;
          network = true;

          expand = true;
        };
      }
      {
        "search".provider = "duckduckgo";
      }
    ];

    customCSS =
      # css
      ''
        .information-widget-search {
          display: none;
        }
      '';
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
    # nameservers = ["127.0.0.1:53"];
  };

  # Block malware, ads, trackers and such
  services.adguardhome = {
    enable = false;
    mutableSettings = false;
    host = "127.0.0.1";
    port = 5001;
    settings = {
      dns = {
        bind_hosts = ["127.0.0.1"];
        port = 53;

        bootstrap_dns = ["1.1.1.1"];
        upstream_dns = ["https://1.1.1.1/dns-query" "https://1.0.0.1/dns-query" "[//fritz.box/]192.168.178.1"];

        local_ptr_upstreams = ["192.168.178.1"];
      };

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
