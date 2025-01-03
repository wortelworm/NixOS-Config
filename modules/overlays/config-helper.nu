#!/usr/bin/env nu

let path_flake = $env.NIXOS_FLAKE_CONFIG | path expand -s
let flake_ref = $'path:($path_flake)'


# An helper program for wortelworm's nixos config,
# uses a bunch of 'nh' commands under the hood.
# By default, the subcommand 'show' is called.
def main []: nothing -> nothing {
    main show
}

# Show the generations available
def "main list" []: nothing -> string {
    # TODO: make the labels show
    # might want to manually read the directories instead,
    # that maybe could even avoid the sudo
    sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
}

# Build and activate the new configuration, without adding it to bootloader
def "main test" []: nothing -> nothing {
    nh os test $flake_ref
}

# Keep only last two root profiles and perform a store garbage collect
def "main clean" []: nothing -> nothing {
    nh clean all --keep 2 --ask

    # Could optimize store, but that is a lot of work for very little gain
}

# Builds an update, only activating on next bootup
def "main update" []: nothing -> nothing {
    # Update flake inputs
    nix flake update --flake $flake_ref

    main switch "updates" --boot
}

# Find out what the last generation number was
def last-generation-number []: nothing -> int {
    ls --short-names /nix/var/nix/profiles/
        | each {|elt| $elt.name | parse 'system-{generation}-link' | $in.generation | into int}
        | flatten
        | math max
}

# Activate new configuration and push to github
def "main switch" [
    description: string, # Can only contain letters, numbers and spaces!!
    --boot # Only activate on next boot
]: nothing -> nothing {

    let next_generation = 1 + (last-generation-number)
    let cleaned_desc = $description | str replace ' ' '_'

    # TODO: make the label show up in boot menu and using 'list' subcommand
    $env.NIXOS_LABEL = $cleaned_desc

    # build the system and check for errors
    # nushell will automaticly exit if this command fails
    nh os build $flake_ref

    let hostname = sys host | get hostname
    let commit_msg = $'($description) - ($hostname) ($next_generation)'

    # Push git changes
    cd $path_flake
    git add -A
    git commit -m $commit_msg
    git push

    # Do the actual activation
    if $boot {
        nh os boot $flake_ref
    } else {
        nh os switch $flake_ref
    }
}

# Will result in local datetime
def flake-inputs-datetimes [] {
    let lockfile = $'($path_flake)/flake.lock'
    let json = open $lockfile | from json
    let version = $json | get version
    if $version != 7 {
        error make {msg: $'Expected flake version 7, instead version is ($version)!'}
    }

    let root_name = $json | get root
    $json
        | get nodes
        | transpose name value
        | each {|elt|
            if $elt.name == $root_name {
                return
            }
            # Convert seconds to nanoseconds
            # It is in utc timezone, but we want to convert it to local anyway
            let datetime = $elt.value
                | get locked.lastModified
                | $in * 1_000_000_000
                | into datetime -z l

            {datetime: $datetime, name: $elt.name}
        }
}


# Shows the lastest flake input datetime
def "main show" []: nothing -> nothing {
    let latest = flake-inputs-datetimes
        | each {|elt| $elt.datetime} 
        | math max

    print $"Latest input is from ($latest | date humanize) \(($latest | format date '%Y-%m-%d %H:%M:%S'))"
}

