{pkgs, ...}: {
  home.packages = with pkgs; [
    obsidian
    onedrivegui
    thunderbird
    vlc
    flup

    # to prevent the initial grey screen on login,
    # I dont know how, and now it is not even starting
    # should really look into an alternative discord client
    # something like abaddon maybe?
    discord
    # todo: figure out how to make blender use nvidia drivers
    # blender

    # remote desktop
    remmina
  ];

  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisablePocket = true;
      Preferences = {
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.search.order.1" = "DuckDuckGo";

        # Make fullscreen of fullscreen not actually fullscreen
        # This option cannot be actually set using a policy,
        # so need to set it using about:config anyway
        "full-screen-api.ignore-widgets" = true;
      };
    };
  };
}
