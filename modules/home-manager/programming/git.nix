{
  lib,
  pkgs,
  ...
}: {
  # Maybe look at gitui someday in the future
  # Or maybe an alternative system like:
  # - https://github.com/jj-vcs/jj
  # - https://www.fossil-scm.org/
  # - https://pijul.org/

  programs.lazygit = {
    enable = true;
    settings = {
      gui = {
        # This weird format is from golang, see
        # https://pkg.go.dev/time#Layout
        timeFormat = "02 Jan 2006";
        shortTimeFormat = "15:04 today";
      };
      # Using delta as a pager, with a bunch of settings copied from
      #     https://github.com/jesseduffield/lazygit/blob/master/docs/Custom_Pagers.md
      git = {
        pagers = [
          {
            pager = "${lib.getExe pkgs.delta} --paging=never --dark --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"";
          }
        ];
        autoFetch = false;
      };
    };
  };

  # Replace the default git diff
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "wortelworm";
        email = "wortelworm@gmail.com";
      };

      init.defaultBranch = "main";
      pull.rebase = false;

      core = {
        # Default compression level, from 1 to 9, with 9 being the slowest
        compression = 9;
        whitespace = "error";
      };

      status = {
        branch = true;
        showStash = true;
      };

      diff.interHunkContext = 10;
    };
  };
}
