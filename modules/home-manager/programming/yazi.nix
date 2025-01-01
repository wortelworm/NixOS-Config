{
  lib,
  pkgs,
  ...
}: let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "235437cf3632a3cafe37ec1b22059e4b014a7aff";
    hash = "sha256-LxWc0hFSj1cp9/aWmN2mmojcQnvFl3meZ96CIbTt2f0=";
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
    rev = "247f49da1c408235202848c0897289ed51b69343";
    hash = "sha256-0J6hxcdDX9b63adVlNVWysRR5htwAtP5WhIJ2AK2+Gs=";
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
    theme.flavor.use = "onedark";
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
