# This is a port of my config helper to justfile, now with a different workflow

set shell := ['nu', '-c']
alias s := show
alias l := list
alias t := test

path_flake := `pwd`
flake_ref := "path:" + path_flake

profiles_path := '/nix/var/nix/profiles'
generations_toml := '/boot/nixos-generations.toml'

# Shows this list
default:
    just --list

# List past generations
[group("info")]
list:
    open '{{generations_toml}}'

# Show days since latest flake input
[group("info")]
show:
    #!/usr/bin/env nu
    let json = open '{{path_flake}}/flake.lock' | from json

    let version = $json | get version
    if $version != 7 {
        error make {msg: $'Expected flake version 7, instead version is ($version)!'}
    }

    let root_name = $json | get root
    let latest = $json
        | get nodes
        | transpose name value
        | each {|elt|
            if $elt.name == $root_name {
                return
            }

            # The lockfile datetime is in seconds of unix time
            let datetime = $elt.value.locked.lastModified
                | into datetime --timezone LOCAL --format '%s'

            $datetime
        }
        | math max

    let days = ((date now) - $latest) / 1day | math round --precision 1
    let formatted = $latest | format date '%Y-%m-%d %H:%M:%S'

    print $"Latest input is from ($days) days ago \(($formatted))"

# Removes all generations but the 2 last ones
[group("modify")]
clean:
    nh clean all --keep 2 --ask

# Test out current configuration, without adding to bootloader
[group("modify")]
test:
    nh os test '{{flake_ref}}'

# Test out current configuration offline.
[group("modify")]
test-offline:
    nh os test '{{flake_ref}}' -- --offline

# Update flake inputs, commit, activate on next boot
[group("modify")]
update:
    #!/usr/bin/env nu
    let workspace_dirty = git status -s | lines | length | $in != 1
    if $workspace_dirty {
        error make {
            msg: 'Cannot update when workspace is dirty!'
        }
    }

    # This command does the actual work
    nix flake update --flake {{flake_ref}}

    git add -A
    git commit -m 'Updates'
    git push

    just switch-boot

# Switch to generation and record it
[group("modify")]
switch: log-next-generation-to-boot-partition
    nh os switch '{{flake_ref}}'


# Switch to generation on next boot and record it
[group("modify")]
switch-boot: log-next-generation-to-boot-partition
    nh os boot '{{flake_ref}}'

[private]
log-next-generation-to-boot-partition:
    #!/usr/bin/env nu
    let workspace_dirty = git status -s | lines | length | $in != 1

    if $workspace_dirty {
        error make {
            msg: 'Do not create a generation when the workspace is dirty!'
        }
    }

    let last_commit_id = git log -n 1 --pretty=%h
    let last_commit_desc = git log -n 1 --pretty=%s

    let description = $'($last_commit_id) - ($last_commit_desc)';

    let last_generation = ls --short-names /nix/var/nix/profiles
        | get name
        | parse "system-{generation}-link"
        | get generation
        | each {|i| $i | into int}
        | math max

    let prev = if ('{{generations_toml}}' | path exists) {
        # Note that the open function automatically converts from toml to nu object
        open '{{generations_toml}}'
    } else {
        {}
    };

    let new = $prev | merge { ($last_generation | $in + 1 | into string): $description } | sort

    $new | to toml | sudo cp /dev/stdin '{{generations_toml}}'
