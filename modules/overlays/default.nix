{pkgs, ...}: {
  nixpkgs.overlays = [
    (final: prev: {
      wortel-config-helper = pkgs.callPackage ./config-helper.nix {};
      flup = pkgs.callPackage ./flup.nix {};
      vimPlugins =
        prev.vimPlugins
        // {
          vim-jukit = pkgs.callPackage ./vim-jukit.nix {};
        };
    })
  ];
}
