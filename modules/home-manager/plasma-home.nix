{ ... }:

{
  # see https://github.com/pjones/plasma-manager
  # it does not work great, something is wrong with the size of the bars
  # if this project has matured a bit more I might try again.

  # things that are to be configured:
  #   theme & wallpaper
  #   virtualDesktops
  #   effects: cube and wobbly windows
  #   application launcher
  #   caps+esc swapped
  #   delay and rate for repeated keys

  programs.plasma = {
    enable = (abort "Do not use plasma-home yet!");

    # anything not configured here will be set to its defaults
    overrideConfig = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = ../../resources/wallpaper.png;
    };
    
    kwin.virtualDesktops = {
      rows = 3;
      number = 9;
    };

    configFile."kwinrc".Plugins = {
      cubeEnabled = true;
      wobblywindowsEnabled = true;
    };

    panels = [
      # Windows-like panel at the bottom
      {
        location = "down";
        height = 44;
        hiding = "autohide";
        # opacity does not seem to be supported yet...
        floating = false;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
      # Global menu at the top
      # first time seeing that this is possible,
      # I dont think I want to use this though
      # {
      #   location = "top";
      #   height = 26;
      #   widgets = [
      #     "org.kde.plasma.appmenu"
      #   ];
      # }
    ];
  };
}
