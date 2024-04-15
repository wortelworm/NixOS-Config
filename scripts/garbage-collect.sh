#!/usr/bin/env bash
# note: boot options only gets deleted with rebuild!
# also, the profiles are located at /nix/var/nix/profiles/
sudo nix-env --delete-generations +10 --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage

# I could also optimize store, but this is a lot of 
# computation for relatively very little gain.
