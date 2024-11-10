{pkgs, ...}: {
  nixpkgs.overlays = [
    (final: prev: {
      flup = pkgs.callPackage ./flup.nix {};
    })
  ];
}
