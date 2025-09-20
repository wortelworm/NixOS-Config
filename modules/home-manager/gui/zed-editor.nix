{
  lib,
  pkgs,
  pkgs-unstable,
  wortel,
  ...
}: let
  lang = wortel.programmingLanguages;
in {
  # TODO:
  #   Disabling lsp by default, manually starting
  #   Better syntax highlighting for nix files?
  #   Fix icons in terminal not using font or something
  #   tabbing through open files (maybe change something in kanata as well)
  #   compitest
  #   Highlight TODO's (see https://github.com/zed-industries/extensions/issues/523)
  programs.zed-editor = lib.mkIf wortel.textEditors.zed-editor {
    enable = true;

    package = pkgs-unstable.zed-editor;

    # Added here instead of in the lsp, so that tasks can also make use of tinymist
    extraPackages = lib.optionals lang.typst [
      pkgs.tinymist
    ];

    extensions =
      [
        "material-icon-theme"
        "nix"
        "nu"
      ]
      ++ lib.optionals lang.rust [
        "toml"
      ]
      ++ lib.optionals lang.typst [
        # tinymist is installed system-wide, this plugin will pick up on that
        "typst"
      ]
      ++ lib.optionals lang.haskell [
        "haskell"
      ]
      ++ lib.optionals lang.beam [
        "elixir"
      ];

    userSettings = {
      # TODO: helix mode?
      # Maybe just use the default zed mode with homemods instead?
      # vim_mode = true;

      # For now, testing
      # agent.enabled = false;
      # features.edit_prediction_provider = "none";

      # TODO: whenever 0.197 is out on unstable nix, use this option instead
      # disable_ai = true;

      hour_format = "hour24";
      calls.mute_on_join = true;

      terminal = {
        # Is installed in ../../nixos/programs.nix
        # Patched font so that starship works
        # Note that the buffer font already has ligatures and such
        font_family = "JetBrainsMono Nerd Font";

        # By default it uses bash
        shell.program = "nu";
      };

      icon_theme = "Material Icon Theme";

      inlay_hints.enabled = true;

      languages = {
        Nix.language_servers = ["nixd" "!nil"];
      };

      lsp = {
        rust-analyzer = lib.mkIf lang.rust {
          # This should by installed via rustup,
          # to match the way helix works
          binary.path = "rust-analyzer";

          settings.check.command = "clippy";
        };
        nixd = {
          binary.path = lib.getExe pkgs.nixd;
          settings.formatting.command = ["alejandra"];
        };
        elixir-ls = lib.mkIf lang.beam {
          binary.path = lib.getExe pkgs.elixir-ls;
        };
        hls = lib.mkIf lang.haskell {
          binary.path = lib.getExe pkgs.haskell-ghcup-lsp;
        };
        omnisharp = lib.mkIf lang.mono {
          binary.path = lib.getExe pkgs.omnisharp-roslyn;
        };
      };
    };
  };

  # Zed really wants to download the debug adapter itself,
  # but that version is not patched for use on nixos.
  # So instead we manually insert the debugger in here.
  # TODO: look at the code in zed to find if this can be done better
  xdg.dataFile."zed/debug_adapters/CodeLLDB/CodeLLDB_v1.11.5/extension" =
    lib.mkIf
    (wortel.textEditors.zed-editor && (lang.rust || lang.cpp))
    {
      source = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/";
    };

  # FIXME: configure via zed-editor.userTasks when updating from homemanager 25.05
  xdg.configFile."zed/tasks.json" = lib.mkIf (wortel.textEditors.zed-editor && lang.typst) {
    text = builtins.toJSON [
      {
        label = "Tinymist: preview file";

        # This works, but only updates on save instead of every edit like in helix.
        # Propably need to wait for input monitoring in upstream.
        # Maybe this would help: https://github.com/zed-industries/zed/issues/13756
        # TODO: maybe just configure autosave timeout?
        command = "tinymist";
        args = ["preview" "$ZED_FILE"];
        reveal = "never";
        hide = "always";
      }
    ];
  };
}
