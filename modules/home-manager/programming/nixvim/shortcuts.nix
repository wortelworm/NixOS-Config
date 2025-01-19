{lib, ...}: {
  programs.nixvim = {
    globals.mapleader = " ";

    keymaps = let
      normalVisual =
        lib.mapAttrsToList
        (key: action: {
          mode = ["n" "v"];
          inherit action key;
        })
        {
          # show terminal
          "<C-\\>" = "<cmd>ToggleTerm<CR>";

          # hop!
          "f" = "<cmd>HopWord<CR>";

          # Setup for custom keybinds
          ";" = "<NOP>";
          "<space>" = "<NOP>";

          # Telescope
          "<space>f" = "<cmd>Telescope find_files<CR>";
          "<space>S" = "<cmd>Telescope live_grep<CR>";
          "<space>b" = "<cmd>Telescope buffers<CR>";
          "gd" = "<cmd>Telescope lsp_definitions<CR>";
          "gr" = "<cmd>Telescope lsp_references<CR>";

          # Created with help from
          #     https://github.com/nvim-telescope/telescope.nvim/issues/605
          "<space>g" = "<cmd>lua require('telescope.builtin').git_status({previewer=(require('telescope.previewers').new_termopen_previewer{get_command=function(entry) return {'sh','-c','git diff '.. entry.path .. ' | delta'} end})})<CR>";
          "<space>c" = "<cmd>lua require('telescope.builtin').git_bcommits({previewer=(require('telescope.previewers').new_termopen_previewer{get_command=function(entry) return {'sh','-c','git diff '.. entry.path .. '^! -- ' .. entry.current_file .. ' | delta'} end})})<CR>";

          "<space>e" = "<cmd>Yazi<CR>";

          # Lsp
          # For hover, press 'K'
          "<space>a" = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          "gD" = "<cmd>lua vim.lsp.buf.declaration()<CR>";
          "<space>r" = "<cmd>lua vim.lsp.buf.rename()<CR>";
          "<space>d" = "<cmd>lua vim.diagnostic.open_float()<CR>";
          "<space>l" = "<cmd>lua require('lsp_lines').toggle()<CR>";
          "<CS-i>" = "<cmd>lua vim.lsp.buf.format()<CR>";

          # Debugger
          "<space>Gc" = "<cmd>lua require('dap').continue()<CR>";
          "<space>Gt" = "<cmd>lua require('dap').terminate()<CR>";
          "<space>Gn" = "<cmd>lua require('dap').step_over()<CR>";
          "<space>Gi" = "<cmd>lua require('dap').step_into()<CR>";
          "<space>Go" = "<cmd>lua require('dap').step_out()<CR>";
          "<space>Gb" = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
          "<space>G<C-c>" = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";

          # Competitest
          ";p" = "<cmd>CompetiTest receive problem<CR>";
          ";r" = "<cmd>CompetiTest run<CR>";
          ";a" = "<cmd>CompetiTest add_testcase<CR>";
          ";e" = "<cmd>CompetiTest edit_testcase<CR>";
          ";l" = "<cmd>CompetiTest delete_testcase<CR>";
          ";c" = "<cmd>CompetiTest convert auto<CR>";

          # resize windows with arrows
          "<C-Up>" = "<cmd>resize -2<CR>";
          "<C-Down>" = "<cmd>resize +2<CR>";
          "<C-Left>" = "<cmd>vertical resize +2<CR>";
          "<C-Right>" = "<cmd>vertical resize -2<CR>";
        };
      vni =
        lib.mapAttrsToList
        (key: action: {
          mode = ["n" "v" "i"];
          inherit action key;
        })
        {
          # paste
          # TODO make copying work...
          "<CS-c>" = "\"+y";
          "<CS-x>" = "\"+c";
          "<CS-v>" = "\"+p";

          # saving
          "<C-s>" = "<cmd>w<CR>";
        };
    in
      normalVisual ++ vni;
  };
}
