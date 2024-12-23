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
          "<space>s" = "<cmd>Telescope find_files<CR>";
          "<space>S" = "<cmd>Telescope live_grep<CR>";
          "<space>b" = "<cmd>Telescope buffers<CR>";
          "<space>d" = "<cmd>Telescope lsp_definitions<CR>";
          "<space>R" = "<cmd>Telescope lsp_references<CR>";

          # Created with help from
          #     https://github.com/nvim-telescope/telescope.nvim/issues/605
          "<space>g" = "<cmd>lua require('telescope.builtin').git_status({previewer=(require('telescope.previewers').new_termopen_previewer{get_command=function(entry) return {'sh','-c','git diff '.. entry.path .. ' | delta'} end})})<CR>";
          "<space>c" = "<cmd>lua require('telescope.builtin').git_bcommits({previewer=(require('telescope.previewers').new_termopen_previewer{get_command=function(entry) return {'sh','-c','git diff '.. entry.path .. '^! -- ' .. entry.current_file .. ' | delta'} end})})<CR>";

          "<space>e" = "<cmd>Yazi<CR>";

          # Lsp
          # For hover, press 'K'
          "<space>a" = "<cmd>lua vim.lsp.buf.code_action()<CR>";
          "<space>D" = "<cmd>lua vim.lsp.buf.declaration()<CR>";
          "<space>r" = "<cmd>lua vim.lsp.buf.rename()<CR>";
          "<space>o" = "<cmd>lua vim.diagnostic.open_float()<CR>";
          "<space>l" = "<cmd>lua require('lsp_lines').toggle()<CR>";
          "<CS-i>" = "<cmd>lua vim.lsp.buf.format()<CR>";

          # Debugger
          "<F5>" = "<cmd>lua require('dap').continue()<CR>";
          "<F8>" = "<cmd>lua require('dap').terminate()<CR>";
          "<F10>" = "<cmd>lua require('dap').step_over()<CR>";
          "<F11>" = "<cmd>lua require('dap').step_into()<CR>";
          "<F12>" = "<cmd>lua require('dap').step_out()<CR>";
          ";d" = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
          ";s" = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";

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
