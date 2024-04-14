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

    panels = [
      # Windows-like panel at the bottom
      {
        location = "down";
        height = 48;
        hiding = "autohide";
        # opacity does not seem to be supported yet...
        # floating is documented as and only works on plasma6,
        # even though it is also an option in plasma5...
        # floating = true;
        widgets = [
          "org.kde.plasma.kickoff"
          # We can also configure the widgets. For example if you want to pin
          # konsole and dolphin to the task-launcher the following widget will
          # have that.
          {
            name = "org.kde.plasma.icontasks";
            config = {
              General.launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"

                # todo: make these work
                "firefox"
                "codium"
              ];
            };
          }
          "org.kde.plasma.marginsseperator"
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