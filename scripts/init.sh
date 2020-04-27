#!/bin/bash

if ! [ -e ~/.config/nixpkgs/config.nix]; then
    mkdir -p ~/.config/nixpkgs
    ln -s ~/nix-cloud/.config/nixpkgs/config.nix ~/.config/nixpkgs
fi

if ! which nix-env 2> /dev/null; then
  # Install nix
  curl https://nixos.org/nix/install | bash
  # Initialize env vars
  . ~/.nix-profile/etc/profile.d/nix.sh
fi

if ! nix-env -q | grep -q user-packages; then
  # Install user packages from ~/.config/nixpkgs
  nix-env -i user-packages
fi