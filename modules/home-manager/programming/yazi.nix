{
  lib,
  pkgs,
  ...
}: let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "4b027c79371af963d4ae3a8b69e42177aa3fa6ee";
    hash = "sha256-auGNSn6tX72go7kYaH16hxRng+iZWw99dKTTUN91Cow=";
  };

  yazi-onedark = pkgs.fetchFromGitHub {
    owner = "BennyOe";
    repo = "onedark.yazi";
    rev = "fa1da70556a5654f5d40d063a95e55ecc63b3ef7";
    hash = "sha256-SJdkLjF2i5/G0H/x9kTPXv/ozzMO1WhddWMjZi6+x3A=";
  };

  yazi-plugin-starship = pkgs.fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "starship.yazi";
    rev = "6c639b474aabb17f5fecce18a4c97bf90b016512";
    hash = "sha256-bhLUziCDnF4QDCyysRn7Az35RAy8ibZIVUzoPgyEO1A=";
  };
in {
  # Note that right now version 0.4 is under development,
  # with changes to the plugin api

  # Also note that help is available by pressing <F1> or '~'
  programs.yazi = {
    enable = true;

    shellWrapperName = "y";
    enableBashIntegration = true;

    keymap.manager.prepend_keymap = [
      {
        on = "<C-n>";
        run = ''shell '${lib.getExe pkgs.ripdrag} "$@" --all --and-exit --no-click 2>/dev/null &' --confirm'';
      }
    ];

    settings = {
      manager.sort_by = "natural";

      preview = {
        max_width = 1000;
        max_height = 1000;
      };

      # Make the git plugin work
      plugin.prepend_fetchers = [
        {
          id = "git";
          name = "*";
          run = "git";
        }
        {
          id = "git";
          name = "*/";
          run = "git";
        }
      ];
    };

    # Theming
    theme.flavor.dark = "onedark";
    flavors.onedark = yazi-onedark;

    # Plugins
    initLua =
      # lua
      ''
        require("git"):setup()
        require("full-border"):setup()
        require("starship"):setup()
      '';

    plugins = {
      git = "${yazi-plugins}/git.yazi/";
      full-border = "${yazi-plugins}/full-border.yazi/";
      starship = "${yazi-plugin-starship}";
    };
  };
}
