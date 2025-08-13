{pkgs, ...}: {
  imports = [
    ./terminal.nix
    ./zed-editor.nix
    ./vscode.nix
    ./plasma-home.nix
    ./hyprland.nix
  ];

  # These are misc thing that need a proper home
  home.packages = with pkgs; [
    # obsidian # no longer used
    thunderbird
    remmina

    # Do I really need these?
    vlc
    zathura
    chromium
  ];

  # TODO: blender

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
