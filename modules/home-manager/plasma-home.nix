{ ... }:

{
  # see https://github.com/pjones/plasma-manager
  programs.plasma = {
    enable = true;

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
      # cubeEnabled = true;
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
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General.launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"

                # todo: make these work
                "applications:firefox"
              ];
            };
          }
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