
# Settings
$env.config = {
    show_banner: false,
    edit_mode: vi,
    cursor_shape: {
        vi_insert: blink_line,
        vi_normal: blink_block,
    }
}

# Initial prompt
do {
    use std
    std ellie | print
}

# Shell aliases
alias vi = nvim

alias cr = cargo run
alias ct = cargo test
alias cc = cargo clippy

alias g = lazygit
alias gs = git status

alias f = fastfetch

alias n = wortel-config-helper

# List files and directories, sorted by type and name
def l [] {
    ls | sort-by type name -i
}

# Enter a shell.nix
def ns [
    initial_command?: string # Command to run in the nix shell
    --packages (-p): string # Package to be made available
] {
    # Is there a better way of doing this?
    match [$initial_command, $packages] {
        [null, null] => (nix-shell --command 'nu')
        [null, _   ] => (nix-shell --command 'nu' --packages $packages)
        [_   , null] => (nix-shell --command $'nu -e "($initial_command)"')
        [_   , _   ] => (nix-shell --command $'nu -e "($initial_command)"' --packages $packages)
    }
}

# Show help page, piped into bat
def --wrapped hb [...rest] {
    try {
        help ...$rest | bat
    } catch {
        nu -c $'($rest | str join " ") --help' | bat
    }
}

# The z command is only declared later in the config.nu file,
# so instead just use zoxide directly
#
# Not intended for use outside of the config.nu, use 'z' instead
def --env manual-zoxide-change-dir [...rest] {
    # Could exclude current directory, but not needed here
    zoxide query ...$rest | cd $in
}

# Go to directory using zoxide, then run vi
def --env v [...rest] {
    manual-zoxide-change-dir ...$rest
    vi
}

# Go to directory using zoxide, then run vi in a nix-shell
def --env vs [...rest] {
    manual-zoxide-change-dir ...$rest
    ns vi
}

# Go to directory using zoxide, then run a nix-shell
def --env zs [...rest] {
    manual-zoxide-change-dir ...$rest
    ns
}

# Go to directory using zoxide, then run lazygit
def --env zg [...rest] {
    manual-zoxide-change-dir ...$rest
    lazygit
}


