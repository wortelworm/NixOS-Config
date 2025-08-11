{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./yazi.nix
    ./funs.nix
  ];

  # Nushell is so much better than bash!!!!
  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;

    # For whatever reason, last update the carapace completion in nushell stopped working
    # In bash it still works, and I cannot find the nixpkgs/home-manager commit that broke it...
    # Somehow I did find this workaround, which fixes it for now
    #
    # Source for the carapace code: https://github.com/nix-community/home-manager/blob/release-25.05/modules/programs/carapace.nix
    extraConfig = ''
      source ${
        pkgs.runCommand "carapace-nushell-config.nu" {} ''
          ${lib.getExe pkgs.carapace} _carapace nushell | sed 's|"/homeless-shelter|$"($env.HOME)|g' >> "$out"
        ''
      }

      $env.config.completions.external.completer = do $env.config.completions.external.completer
    '';
  };

  # Automaticly adds completions for some many programs
  programs.carapace = {
    enable = true;

    # Done manually to fix issue above
    enableNushellIntegration = false;
  };

  # Database location: $XDG_DATA_HOME/zoxide/db.zo
  # Bash and nushell integration is enabled by default in home-manager
  programs.zoxide.enable = true;

  # TODO: find a good way of having a terminal with helix?
  programs.zellij.enable = true;

  # Replacing default bash/nushell prompt
  programs.starship = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };
}
