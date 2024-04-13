{ ... }:

{
  programs.plasma = {
    enable = true;

    # anything not configured here will be set to its defaults
    overrideConfig = true;

    workspace = {
      clickItemTo = "select";
    };
  };
}