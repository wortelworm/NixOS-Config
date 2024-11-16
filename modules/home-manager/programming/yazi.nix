{
  pkgs,
  pkgs-unstable,
  ...
}: {
  # Yazi plugins and flavors are not yet supported in
  # home-manager 24.05, so instead I'll package them myself
  xdg.configFile = {
    "yazi/plugins".source = pkgs.stdenv.mkDerivation {
      name = "yazi-plugins";

      src = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "235437cf3632a3cafe37ec1b22059e4b014a7aff";
        hash = "sha256-LxWc0hFSj1cp9/aWmN2mmojcQnvFl3meZ96CIbTt2f0=";
      };

      installPhase = ''
        for plug in "git" "full-border"; do
          mkdir -p $out/"$plug".yazi
          cp -r "$plug".yazi $out
        done
      '';
    };
    "yazi/init.lua".text =
      # lua
      ''
        require("git"):setup()
        require("full-border"):setup()
      '';
    "yazi/flavors/onedark.yazi".source = pkgs.fetchFromGitHub {
      owner = "BennyOe";
      repo = "onedark.yazi";
      rev = "fa1da70556a5654f5d40d063a95e55ecc63b3ef7";
      hash = "sha256-SJdkLjF2i5/G0H/x9kTPXv/ozzMO1WhddWMjZi6+x3A=";
    };
  };

  programs.yazi = {
    enable = true;
    # Current 24.05 version: 0.2.5
    # Current unstalbe version: 0.3.3
    # There are some noteable things missing like:
    # mouse support, optimizations, git integeration
    # Also note that right now version 0.4 is under development,
    # with changes to the plugin api
    package = pkgs-unstable.yazi;

    # Theme is imported above
    theme.flavor.use = "onedark";

    keymap.manager.prepend_keymap = [
      {
        on = "<C-n>";
        run = ''shell '${pkgs.ripdrag}/bin/ripdrag "$@" -x 2>/dev/null &' --confirm'';
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
  };
}
