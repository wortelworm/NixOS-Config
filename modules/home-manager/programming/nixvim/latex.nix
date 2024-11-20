{pkgs, ...}: let
  latex = pkgs.texliveFull;
in {
  home.packages = [latex];

  # Source: https://github.com/lervag/vimtex/issues/576
  # Remove .synctex.gz files with clean
  home.file.".latexmkrc".text = "push @generated_exts, \"synctex.gz\";";

  programs.nixvim = {
    plugins = {
      vimtex = {
        enable = true;
        texlivePackage = latex;
        settings.view_method = "zathura";
      };

      # The ignore install does not appear to be working :(
      # TODO
      # treesitter.ignoreInstall = ["latex"];
      # treesitter.settings.highlight.disable = ["latex"];
    };
  };
}
