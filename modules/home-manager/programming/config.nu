
$env.config = {
    show_banner: false,
    edit_mode: vi,
    cursor_shape: {
        vi_insert: line,
        vi_normal: block,
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
    # TODO: the z command is only declared later, so this does not work :(
    z ...$args
    vi
}

