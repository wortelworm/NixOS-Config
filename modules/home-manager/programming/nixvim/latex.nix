{pkgs, ...}: let
  latex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-basic
      latexmk
      amstex
      geometry
      enumitem
      ;
  };
in {
  home.packages = [latex];

  # Source: https://github.com/lervag/vimtex/issues/576
  # Remove .synctex.gz files with clean
  # Note that nowadays latexmk also support the xdg base directories
  xdg.configFile."latexmk/latexmkrc".text = ''
    push @generated_exts, "synctex.gz";
  '';

  programs.nixvim = {
    plugins = {
      vimtex = {
        enable = true;
        texlivePackage = latex;
        settings.view_method = "zathura";
      };

      # Vimtex asks to do this
      treesitter.settings.highlight.disable = ["latex"];

      # TODO: some kind of snippets plugin
    };
  };
}
