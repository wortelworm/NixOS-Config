
# Settings
$env.config = {
    show_banner: false,
    edit_mode: vi,
    cursor_shape: {
        vi_insert: blink_line,
        vi_normal: blink_block,
    }
}

# Initial prompt, if not entering a nix-shell
if ($env.NU_WITHIN_NIX_SHELL? == null) {
    use std
    std ellie | print
}

# Shell aliases
alias j = just
alias vi = nvim

alias cr = cargo run
alias ct = cargo test
alias cc = cargo clippy

alias g = lazygit
alias gs = git status

alias f = fastfetch

alias ns = nix-shell --command 'export NU_WITHIN_NIX_SHELL=1; nu'

# List files and directories, sorted by type and name
def l [] {
    ls | sort-by type name -i
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
def --env manual-zoxide-change-dir [...rest: string] {
    # Could exclude current directory, but not needed here
    zoxide query ...$rest | cd $in
}

# Go to directory using zoxide, then run vi
def --env v [...rest: string] {
    manual-zoxide-change-dir ...$rest
    vi
}

# Go to directory using zoxide, then run a nix-shell
def --env zs [...rest: string] {
    manual-zoxide-change-dir ...$rest
    ns
}

# Go to directory using zoxide, then run lazygit
def --env zg [...rest: string] {
    manual-zoxide-change-dir ...$rest
    lazygit
}

# Go to directory using zoxide, then run helix
def --env h [...rest: string] {
    manual-zoxide-change-dir ...$rest
    hx
}

# Go to directory using zoxide, then run helix in a nix shell
def --env hs [...rest: string] {
    manual-zoxide-change-dir ...$rest
    nix-shell --command 'export NU_WITHIN_NIX_SHELL=1; nu -e "hx"'
}


# Custom completion for bash, because it was not working on it's own or with carapace...
def "manpages" [] {
    ^man -w
    | str trim
    | split row (char esep)
    | par-each { glob $'($in)/man?' }
    | flatten
    | par-each { ls $in | get name }
    | flatten
    | path basename
    | str replace ".gz" ""
}

export extern "man" [
    ...targets: string@"manpages"
]

# Should take a look at better manpages one day again
# alias man = batman
# export extern "batman" [
#     ...targets: string@"manpages"
# ]
