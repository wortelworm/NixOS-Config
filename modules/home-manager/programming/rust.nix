{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rustup
  ];

  programs.bacon = {
    enable = true;

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
