{
  lib,
  pkgs,
  wortel,
  ...
}: {
  imports = [
    ./nixvim
    ./helix.nix
    ./rust.nix
    ./git.nix
  ];

  # All the terminal tooling for various languages
  home.packages = let
    lang = wortel.programmingLanguages;
  in
    with pkgs;
      [
        # nix formatter
        alejandra
      ]
      ++ lib.optionals lang.cpp [
        gcc
        # TODO: what are these for??
        #   gdb
        #   clang-tools
      ]
      ++ lib.optionals lang.typst [
        typst
      ]
      ++ lib.optionals lang.haskell [
        ghc
        cabal-install
        hlint
      ]
      ++ lib.optionals lang.beam [
        elixir
        gleam
        erlang
      ];
}
