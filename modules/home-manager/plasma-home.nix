{inputs, ...}: {
  # see https://github.com/pjones/plasma-manager
  # it does not work great, something is wrong with the size of the bars
  # if this project has matured a bit more I might try again.

  # things that are to be configured:
  #   theme & wallpaper
  #   virtualDesktops
  #   effects: cube and wobbly windows
  #   application launcher
  #   delay and rate for repeated keys
  #   blur strength
  #   shortcuts and hotkeys

  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  programs.plasma = {
    enable = true;

    # anything not configured here will be set to its defaults
    overrideConfig = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = ../../resources/wallpaper.png;
    };

    kwin = {
      virtualDesktops = {
        rows = 3;
        number = 9;
      };
      effects = {
        cube.enable = true;
        wobblyWindows.enable = true;
        blur = {
          enable = true;
          strength = 5;
          noiseStrength = 8;
        };
      };
    };

    panels = [
      # Windows-like panel at the bottom
      {
        location = "bottom";
        hiding = "autohide";
        height = 44;
        floating = false;
        # opacity does not seem to be supported yet...
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    shortcuts."kwin" = {
      "Window Close" = "Meta+Q";
      # might want to configure:
      #     Walk Through Windows [Alternative]
      #     Switch window <direction>
      #     Increase Screen brightness
    };

    hotkeys.commands = {
      open-terminal = {
        key = "Meta+T";
        command = "kitty";
        logs.enabled = false;
      };
      open-browser = {
        key = "Meta+B";
        command = "firefox";
        logs.enabled = false;
      };
    };

    input = {
      keyboard = {
        repeatDelay = 250;
        repeatRate = 40.0;
      };
      touchpads = [
        {
          enable = true;
          naturalScroll = true;

          vendorId = "04f3";
          productId = "31bc";
          name = "ASUE140D:00 04F3:31BC Touchpad";
        }
      ];
    };
  };
}
