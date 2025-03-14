{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs; [
    rustup
  ];

  programs.bacon = {
    enable = true;
    # In 24.11 the version is 3.2.0, unstable is version 3.11.0
    package = pkgs-unstable.bacon;

    settings = {
      default_job = "clippy-all";

      # If I ever create a proper library for other people:
      # jobs.clippy-pedantic = {
      #   command = [
      #     "cargo"
      #     "clippy"
      #     "--all-targets"
      #     "--"
      #     "-W"
      #     "clippy::pedantic"
      #     "-W"
      #     "clippy::nursery"
      #     "-W"
      #     "clippy::unwrap_used"
      #     "-A"
      #   ];
      # };
    };
  };
}
