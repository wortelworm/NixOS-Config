#!/usr/bin/env nu

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
        | each {|row| {
            modified: $row.modified
            generation: ($row.generation | into int)
            label: ($row.label | str replace --all '_' ' ')
        }}
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

    main switch "Updates" --boot
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
    use std;

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

    $cleaned_desc | save --force $path_nixos_label

    # Make sure that the ssh key is cached in agent
    # Note that because github does not actually support remote shell, exit code will be 1.
    # If authentication failed, exit code will be 255
    let res = ssh git@github.com | complete
    if $res.exit_code != 1 {
        error make {msg: "Failed to authenticate to github!"}
    }

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
                | $in * 1sec // 1ns
                | into datetime -z l

            {datetime: $datetime, name: $elt.name}
        }
}


# Shows the lastest flake input datetime
def "main show" []: nothing -> nothing {
    let latest = flake-inputs-datetimes
        | each {|elt| $elt.datetime} 
        | math max

    let days = ((date now) - $latest) / 1day | math round --precision 1
    let formatted = $latest | format date '%Y-%m-%d %H:%M:%S'

    print $"Latest input is from ($days) days ago \(($formatted))"
}

# Provides information about the laptop's battery
def "main bat" []: nothing -> record {
    cd /sys/class/power_supply/BAT0
    
    {
        status: (open status),
        charge: (open capacity),
        health: ((open energy_full | into int) / (open energy_full_design | into int) * 100)
    }
}

# Workaround for COSMIC DE issue
def "main k" []: nothing -> nothing {
    ps --long | where command == "cosmic-applet-bluetooth" | get pid | each {|pid| kill $pid}
}
