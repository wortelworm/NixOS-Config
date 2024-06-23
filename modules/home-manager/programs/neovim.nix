{ inputs, lib, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  # adds and configures neovim using
  # https://github.com/nix-community/nixvim
  # todo: git, zooming in and out,
  # automatic brackets and indentation, clipboard, tabs, better scrolling
  # latex, competative programming, ...
  # transparency?
  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    colorschemes.onedark = {
      enable = true;
      # make sure this is lowercase and matches exactly
      settings.style = "dark";
    };
    
    # use clipboard with ctrl+shift c
    # pasting works, but copying doesnt :(
    clipboard.register = "unnamedplus";

    opts = {
      relativenumber = true;
      number = true; # Display the absolute line number of the current line

      expandtab = true;
      autoindent = true;
      shiftwidth = 4;
    };

    plugins = {
      lualine.enable = true;
      comment.enable = true;
      telescope.enable = true;
      gitgutter.enable = true;
      nvim-autopairs.enable = true;
      diffview.enable = true;
      neoscroll.enable = true;
      # would be cool to see the background as a toggle,
      # but I would need to configure kitty to work with that
      # transparent.enable = true;
      treesitter = {
        enable = true;
        indent = true;
	# maybe disable some contexts because I dont need them all
      };
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
      };
      toggleterm = {
        enable = true;
        settings = {
          direction = "horizontal";
          size = 15;
        };
      };

      lsp = {
        enable = true;
        servers = {
          tsserver.enable = true;
          clangd.enable = true;
          nil-ls.enable = true;

          rust-analyzer = {
            enable = true;
            # these are managed by rustup
            installCargo = false;
            installRustc = false;
          };
        };
      };
      cmp = {
        enable = true;
        settings.sources = [
          {name = "nvim_lsp";}
          {name = "path";}
          {name = "buffer";}
        ];
        settings.mapping = {
          "<C-e>" = "cmp.mapping.close()";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";

          # this is really annoying, can just use tab for this
          # "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };

      
      # todo more stuff
    };

    keymaps = let
      normal =
        lib.mapAttrsToList
        (key: action: {
          mode = "n";
          inherit action key;
        })
        {
          # show tree sidebar
          "<C-b>" = ":Neotree <CR>";

          # show terminal
          "<C-\\>" = ":ToggleTerm <CR>";
          
          # Using tabs like in other programs
          # this is not working ????
          "<C-t> <C-t>" = ":tabnew <CR>";
          "<C-t> l" = ":tabnext + <CR>";
          "<C-t> h" = ":tabnext - <CR>";
          "<C-t> <C-w>" = ":tabclose <CR>";
        };
      visual =
        lib.mapAttrsToList
        (key: action: {
          mode = "v";
          inherit action key;
        })
        {
          
        };
      in
        normal ++ visual;
  };
}
