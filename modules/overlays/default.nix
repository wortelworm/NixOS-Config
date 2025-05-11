{
  lib,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      wortel-config-helper = pkgs.callPackage ./config-helper.nix {};
      vimPlugins =
        prev.vimPlugins
        // {
          vim-jukit = pkgs.callPackage ./vim-jukit.nix {};
        };

      # Helix fork with steel integration
      helix = pkgs.callPackage ((import ./helix.nix) prev) {};
      steel = pkgs.callPackage ./steel.nix {};
      steel-lsp = pkgs.callPackage ./steel-lsp.nix {};

      # Doesn't appear to be using any more storage,
      # just require recompilation
      btop = prev.btop.override {
        # Dedicated nvidia card
        cudaSupport = true;
        # Integrated amd graphics
        rocmSupport = true;
      };

      # Some programs expect the haskell language server
      # to be named 'haskell-language-server-wrapper'
      # I think this is the name that ghcup gives it
      #
      # Also note that with zed for some reason using "$@" doesn't work,
      # in helix it behaves fine. See also:
      #     https://github.com/zed-industries/zed/blob/main/extensions/haskell/src/haskell.rs
      haskell-ghcup-lsp = pkgs.writeShellScriptBin "haskell-language-server-wrapper" ''
        ${lib.getExe' pkgs.haskellPackages.haskell-language-server "haskell-language-server"} lsp
      '';

      # Driver for the MFC-6890CDW brother printer
      # See manual at https://data2.manualslib.com/pdf4/88/8785/878406-brother/mfc6890cdw.pdf?98cb5a127d27427e12826a819236d0bb
      # mfcl8690cdwlpr mfcl3770cdwlpr
      mfc6890cdwlpr = (pkgs.callPackage ./mfc6890cdwlpr.nix {}).driver;
      mfc6890cdwcupswrapper = (pkgs.callPackage ./mfc6890cdwlpr.nix {}).cupswrapper;
    })
  ];
}
