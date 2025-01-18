{
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    steel
  ];
  # Note that this relies on the experimental steel plugin system
  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight";
      editor = {
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        line-number = "relative";
        soft-wrap.enable = true;
      };
      keys.normal = {
        "C-g" = [":new" ":insert-output lazygit" ":buffer-close!" ":redraw" ":reload-all"];
        "C-S-i" = ":format";
      };
    };

    # For all default settings, see:
    #     https://github.com/helix-editor/helix/blob/master/languages.toml
    languages = {
      language-server = {
        # Make sure that rust-analayzer component is present, using:
        # `rustup component add rust-analyzer`
        rust-analyzer.config.check.command = "clippy";

        steel-language-server.command = lib.getExe' pkgs.steel-lsp "steel-language-server";
      };

      language = [
        {
          name = "scheme";
          # TODO
          # formatter = {
          #   command = "raco";
          #   args = ["fmt" "-i"];
          # }
          language-servers = ["steel-language-server"];
        }
        {
          name = "nix";
          formatter.command = "alejandra";
          language-servers = ["nixd"];
        }
      ];
    };

    extraPackages = with pkgs; [
      nixd
      haskell-ghcup-lsp
      texlab
    ];
  };
}
