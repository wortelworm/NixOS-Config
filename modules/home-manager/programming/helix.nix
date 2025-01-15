{pkgs, ...}: {
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
      };

      language = [
        {
          name = "nix";
          formatter.command = "alejandra";
          language-servers = ["nixd"];
        }
      ];
    };

    extraPackages = with pkgs; [
      nixd

      # Just like zed, helix expects the haskell lsp to have specific name
      (pkgs.writeShellScriptBin "haskell-language-server-wrapper" ''
        ${lib.getExe' pkgs.haskellPackages.haskell-language-server "haskell-language-server"} "$@"
      '')
    ];

    # This fork includes the experimental plugin system using steel
    # Revision is of branch 'steel-event-system' on 2025-01-11
    package = pkgs.rustPlatform.buildRustPackage rec {
      pname = "helix";
      version = "unstable-steel";

      # This release tarball includes source code for the tree-sitter grammars,
      # which is not ordinarily part of the repository.
      # src = fetchzip {
      #   url = "https://github.com/helix-editor/helix/releases/download/${version}/helix-${version}-source.tar.xz";
      #   hash = "sha256-R8foMx7YJ01ZS75275xPQ52Ns2EB3OPop10F4nicmoA=";
      #   stripRoot = false;
      # };
      #
      # I hope im not gonna miss them
      src = pkgs.fetchFromGitHub {
        owner = "mattwparas";
        repo = "helix";
        rev = "a9d5557a3b3c11767432bdacd36ccb3bea02bfa5";
        hash = "sha256-o+LmzQToDudSGrB1U7MaYrwt7soc+TLNV7rKtlitgN4=";
      };

      cargoLock = {
        lockFile = "${src}/Cargo.lock";
        allowBuiltinFetchGit = true;
      };

      nativeBuildInputs = with pkgs; [
        git
        installShellFiles
      ];

      env = {
        # disable fetching and building of tree-sitter grammars in the helix-term build.rs
        # Found this in the build of 'evil-helix'
        HELIX_DISABLE_AUTO_GRAMMAR_BUILD = "1";

        HELIX_DEFAULT_RUNTIME = "${placeholder "out"}/lib/runtime";
      };

      postInstall = ''
        # not needed at runtime
        # rm -r runtime/grammars/sources

        mkdir -p $out/lib
        cp -r runtime $out/lib

        # copy tree-sitter grammars from helix package
        # TODO: build it from source instead
        cp -r ${pkgs.helix}/lib/runtime/grammars/* $out/lib/runtime/grammars/

        installShellCompletion contrib/completion/hx.{bash,fish,zsh}
        mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
        cp contrib/Helix.desktop $out/share/applications
        cp contrib/helix.png $out/share/icons/hicolor/256x256/apps
      '';
    };
  };

  home.packages = [
    (pkgs.rustPlatform.buildRustPackage rec {
      pname = "steel";
      version = "unstable";
      src = pkgs.fetchFromGitHub {
        owner = "mattwparas";
        repo = "steel";
        rev = "785312ab654d47dd87c5a2b7a137e9fd9e644346";
        hash = "sha256-vrJlFLkH/2JYPvHWZiNHETMGUsMs0iTzxJ2hKk3rsKQ=";
      };
      cargoLock.lockFile = "${src}/Cargo.lock";
      doCheck = false;
      doInstallCheck = false;
    })
  ];
}
