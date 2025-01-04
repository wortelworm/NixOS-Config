{pkgs, ...}: {
  home.packages = with pkgs; [
    obsidian
    onedrivegui
    thunderbird
    vlc
    zathura

    # Nixos config helpers
    nh
    wortel-config-helper

    # TODO: figure out how to make blender use nvidia drivers
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
