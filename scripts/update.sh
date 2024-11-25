#!/usr/bin/env bash
nix flake update --flake $FLAKE
./boot.sh "updates"
