{
  lib,
  pkgs,
  ...
}: {
  # Wortelworm's Redirection Engine:
  #   just because duckduckgo's bangs are outdated (!nixos, !mcw),
  #   and I don't feel like paying for kagi.
  #   Its pretty nice :)
  #   Starts by default on 0.0.0.0:5100
  systemd.user.services.wortel-redirect = {
    enable = true;
    after = ["network.target"];
    wantedBy = ["default.target"];
    description = "Wortelworm's Redirection Engine";
    serviceConfig = {
      Type = "simple";
      ExecStart = lib.getExe (pkgs.rustPlatform.buildRustPackage rec {
        pname = "wortel-redirect";
        version = "0.1.0";

        src = pkgs.fetchFromGitHub {
          owner = "wortelworm";
          repo = "wortel-redirect";
          tag = version;
          hash = "sha256-kQ1Mb4hTypSFnAv4i0CLmDGiF47BLbiSfsDd7A21Od0=";
        };

        cargoHash = "sha256-T2+L00PEiW9UzQ3w1zlrFECqdtUJBTfe4ACRe9OX3+o=";

        meta.mainProgram = "wortel-redirect";
      });
    };
  };
}
