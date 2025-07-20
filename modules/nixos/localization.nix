{...}: {
  time.timeZone = "Europe/Amsterdam";

  # Internationalisation properties
  # I want most of the stuff in english, except to use metric and such
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Configure keymap in X11
  # TODO: is this even necessary??
  services.xserver = {
    # layout = "us";
    # xkbVariant = "";
    xkb = {
      layout = "us";
      variant = "";
    };
  };
}
