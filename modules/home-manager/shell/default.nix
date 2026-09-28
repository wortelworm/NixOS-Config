{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./yazi.nix
    ./funs.nix
  ];

  # Nushell is so much nicer than bash!
  # But for most interactive use I'm gonna go to fish.
  # Actually, why does fish feel quicker than nushell?
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
  };

  # Important (default) keybinds:
  # ctrl+shift+g: in kitty, pipe output of last command in pager
  # ctrl+e: complete using history
  # ??
  programs.fish = {
    enable = true;
    shellInit =
      # fish
      ''
        set -x fish_greeting

        abbr --add j just
        abbr --add g lazygit
        abbr --add cr cargo run

        alias l '${lib.getExe pkgs.eza} -la'

        function h --wraps y
          cd (zoxide query $argv)
          hx
        end

        function zg --wraps y
          cd (zoxide query $argv)
          lazygit
        end

        function ns --wraps nix-shell
          nix-shell --command 'fish' $argv
        end
      '';
  };

  # Mostly complementary to fish
  home.packages = with pkgs; [
    xh
    dua
  ];

  # Automaticly adds completions for some many programs
  # TODO: re-evaluate now that fish is interactive shell
  programs.carapace.enable = true;

  # Database location: $XDG_DATA_HOME/zoxide/db.zo
  # Bash and nushell integration is enabled by default in home-manager
  programs.zoxide.enable = true;

  # TODO: find a good way of having a terminal with helix?
  programs.zellij.enable = true;

  # Replacing default bash/nushell prompt
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);

    # To clearly differentiate between what shell is currently running,
    # have starship disabled in everything except fish.
    enableBashIntegration = false;
    enableNushellIntegration = false;
  };
}
