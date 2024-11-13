{pkgs, ...}: {
  nixpkgs.overlays = [
    (final: prev: {
      flup = pkgs.callPackage ./flup.nix {};
      vimPlugins =
        prev.vimPlugins
        // {
          vim-jukit = pkgs.callPackage ./vim-jukit.nix {};
        };
    })
  ];
}
