{pkgs, ...}: {
  imports = [
    ./terminal.nix
    ./zed-editor.nix
    ./vscode.nix
    ./plasma-home.nix
  ];

  # These are misc thing that need a proper home
  home.packages = with pkgs; [
    # obsidian # no longer used
    thunderbird
    remmina

    # Do I really need these?
    vlc
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

  # A nice, keyboard controlled, pdf viewer
  programs.zathura = {
    enable = true;
    options = {
      # Copy text to main clipboard on select, instead of the weird 'primary' clipboard
      selection-clipboard = "clipboard";
    };
  };
}
