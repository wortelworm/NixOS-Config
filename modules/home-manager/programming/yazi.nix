{
  lib,
  pkgs,
  ...
}: {
  # Note that right now version 0.4 is under development,
  # with changes to the plugin api

  # TODO:
  #     offline documentation for keymaps
  #     Map <ESC> to quitting
  programs.yazi = {
    enable = true;

    shellWrapperName = "y";
    enableBashIntegration = true;

    keymap.manager.prepend_keymap = [
      {
        on = "<C-n>";
        run = ''shell '${lib.getExe pkgs.ripdrag} "$@" -x 2>/dev/null &' --confirm'';
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

    # Theme is imported below
    theme.flavor.use = "onedark";

    flavors.onedark = pkgs.fetchFromGitHub {
      owner = "BennyOe";
      repo = "onedark.yazi";
      rev = "fa1da70556a5654f5d40d063a95e55ecc63b3ef7";
      hash = "sha256-SJdkLjF2i5/G0H/x9kTPXv/ozzMO1WhddWMjZi6+x3A=";
    };

    # plugins
    initLua =
      # lua
      ''
        require("git"):setup()
        require("full-border"):setup()
      '';

    plugins = let
      # TODO: fetch subdirectory from github?
      yaziPlugins = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "235437cf3632a3cafe37ec1b22059e4b014a7aff";
        hash = "sha256-LxWc0hFSj1cp9/aWmN2mmojcQnvFl3meZ96CIbTt2f0=";
      };
    in {
      git = "${yaziPlugins}/git.yazi/";
      full-border = "${yaziPlugins}/full-border.yazi/";
    };
  };
}
