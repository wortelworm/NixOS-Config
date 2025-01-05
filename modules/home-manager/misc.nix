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

  programs.ssh = {
    enable = true;
    addKeysToAgent = "confirm";

    # Sources:
    #   Github: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints
    userKnownHostsFile = "${pkgs.writeText "known_hosts" ''
      github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
    ''}";
  };
}
