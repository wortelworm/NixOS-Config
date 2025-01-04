#!/usr/bin/env nu
use std

let path_flake = $env.NIXOS_FLAKE_CONFIG | path expand -s
let flake_ref = $'path:($path_flake)'

# I tried to use '$env.NIXOS_LABEL', but it doesn't work
# this could be because of nh or some purity setting
# This location is used by the nixos config in 'modules/default.nix'
let path_nixos_label = $'($path_flake)/nixos-label.txt'


# An helper program for wortelworm's nixos config,
# uses a bunch of 'nh' commands under the hood.
# By default, the subcommand 'show' is called.
def main []: nothing -> nothing {
    main show
}

# Show the generations available
def "main list" []: nothing -> table {
    let base_path = '/nix/var/nix/profiles'
    ls --short-names $base_path
        | each {|row| {
            generation: (
                $row.name
                    | parse "system-{generation}-link"
                    | $in.generation.0?
            )
            modified: $row.modified
            label: (do --ignore-errors {
                open --raw $'($base_path)/($row.name)/nixos-version'
            })
        }}
        | filter {|row|
            $row.generation != null
        }
        | each {|row|
            $row | update generation ($row.generation | into int)
        }
        | sort-by generation
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
    main list
        | each {|row| $row.generation}
        | math max
}

# Activate new configuration and push to github
def "main switch" [
    description: string, # May only contain letters, numbers and spaces
    --boot # Only activate on next boot
]: nothing -> nothing {

    # Documentation for 'system.nixos.label':
    #   May only contain letters, numbers and symbols `:`, `_`, `.` and `-`
    let meta_span = (metadata $description).span
    let cleaned_desc = $description
        | split chars
        | each {|c|
            std assert equal ($c | str length) 1
            if 'a' <= $c and $c <= 'z' {
                return $c
            }
            if 'A' <= $c and $c <= 'Z' {
                return $c
            }
            if '0' <= $c and $c <= '9' {
                return $c
            }
            if $c == ' ' {
                return '_'
            }
            error make {
                msg: 'Description invalid'
                label: {
                    text: 'this must not contain characters other than letters, numbers and spaces'
                    span: $meta_span
                }
            }
        }
        | str join

    $cleaned_desc | save $path_nixos_label

    # Try to do stuff, if fails still want to remove the commit description file
    do --capture-errors {
        # build the system and check for errors
        # nushell will automaticly exit if this command fails
        # and the stderr from this command is forwarded
        nh os build $flake_ref

        let hostname = sys host | get hostname
        let next_generation = 1 + (last-generation-number)
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

    rm $path_nixos_label
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

