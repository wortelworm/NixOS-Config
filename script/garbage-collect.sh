#!/usr/bin/env bash
# note: boot options only gets deleted with rebuild!
# also, the profiles are located at /nix/var/nix/profiles/
sudo nix-collect-garbage --delete-older-than 15d

# I could also optimize store, but this is a lot of 
# computation for very little gain.

# to delete a specific generation, use:
# sudo nix-env --delete-generations {number} --profile /nix/var/nix/profiles/system
# where {number} are specific numbers OR something like +10
