#!/usr/bin/env bash
nh clean all -keep 2 -ask

# note: boot options only gets deleted with rebuild!
# this below is the thing without nh
# also, the profiles are located at /nix/var/nix/profiles/
# sudo nix-env --delete-generations +10 --profile /nix/var/nix/profiles/system
# sudo nix-collect-garbage

# I could also optimize store, but this is a lot of 
# computation for relatively very little gain.
