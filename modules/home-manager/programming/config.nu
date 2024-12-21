
$env.config = {
    show_banner: false,
    edit_mode: vi,
    cursor_shape: {
        vi_insert: blink_line,
        vi_normal: blink_block,
    }
}

# Shell aliases
alias ns = nix-shell
alias vi = nvim +"Telescope find_files"

alias cr = cargo run
alias ct = cargo test
alias cc = cargo clippy

alias g = lazygit
alias gs = git status

alias f = fastfetch

def l [] {
    ls | sort-by type name -i
}

def v [...args] {
    # The z command is only declared later,
    # so instead just zoxide directly
    zoxide query ...$args | cd $in
    vi
}

