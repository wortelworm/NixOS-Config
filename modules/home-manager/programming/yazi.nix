{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "79193b3917d0f1b82ee41b4e64ae4df58f2284f6";
    hash = "sha256-ZLL/dFjNsryjm51kFNOmw5DhSGl2K5IfatHpe1PkuFE=";
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

    package = pkgs-unstable.yazi;

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

    # The fake function should be removed once home-manager 25.05 comes around
    # This is because the new version of yazi plugins uses `main.lua` instead of `init.lua`
    plugins = let
      fake = plugin:
        pkgs.symlinkJoin {
          name = "fake-yazi-plugin";
          paths = [plugin];
          postBuild = ''
            touch $out/git.yazi/init.lua
            touch $out/full-border.yazi/init.lua
          '';
        };
    in {
      git = "${fake yazi-plugins}/git.yazi/";
      full-border = "${fake yazi-plugins}/full-border.yazi/";
      starship = "${yazi-plugin-starship}";
    };
  };
}
