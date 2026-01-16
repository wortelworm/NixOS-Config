{
  lib,
  pkgs,
  ...
}: {
  # Would love to set yazi as default file picker, but all my attempts so far have not worked.

  # Note that help is available within yazi by pressing <F1> or '~'
  programs.yazi = {
    enable = true;

    shellWrapperName = "y";

    keymap.mgr.prepend_keymap = [
      {
        on = "<C-n>";
        run = ''shell '${lib.getExe pkgs.ripdrag} "$@" --all --and-exit --no-click 2>/dev/null &' --confirm'';
        desc = "Drag and drop selected files out of the terminal";
      }
      {
        on = "<C-d>";
        run = "plugin diff";
        desc = "Diff the selected with the hovered file";
      }
      {
        on = "C";
        run = "plugin ouch";
        desc = "Compress with ouch";
      }
    ];

    settings = {
      # Make the git plugin work
      plugin = {
        prepend_fetchers = [
          {
            id = "git";
            url = "*";
            run = "git";
          }
          {
            id = "git";
            url = "*/";
            run = "git";
          }
        ];
        prepend_previewers = [
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch --show-file-icons";
          }
        ];
      };
    };

    # Required for the ouch.yazi plugin, for working with compression/decompression
    extraPackages = [
      pkgs.ouch
    ];

    # Unfortunatly yazi themes are not in nixpkgs yet, so package ourselves
    # TODO: the github directory contains more than just the theme, remove unnessary files
    theme.flavor.dark = "tokyo-night";
    flavors.tokyo-night = pkgs.fetchFromGitHub {
      owner = "BennyOe";
      repo = "tokyo-night.yazi";
      rev = "8e6296f14daff24151c736ebd0b9b6cd89b02b03";
      hash = "sha256-LArhRteD7OQRBguV1n13gb5jkl90sOxShkDzgEf3PA0=";
    };

    # Plugins
    initLua =
      # lua
      ''
        require("full-border"):setup()
        require("git"):setup()
        require("starship"):setup()
      '';

    plugins = {
      diff = pkgs.yaziPlugins.diff;
      full-border = pkgs.yaziPlugins.full-border;
      git = pkgs.yaziPlugins.git;
      ouch = pkgs.yaziPlugins.ouch;
      starship = pkgs.yaziPlugins.starship;
    };
  };
}
