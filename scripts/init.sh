#!/bin/bash

if ! [ -e ~/.config/nixpkgs/config.nix]; then
    mkdir -p ~/.config/nixpkgs
    ln -s ~/nix-cloud/.config/nixpkgs/config.nix ~/.config/nixpkgs
fi

echo User: $USER

if ! which nix-env 2> /dev/null; then
  curl https://nixos.org/nix/install | bash
  . ~/.nix-profile/etc/profile.d/nix.sh
  nix-env -iA nixpkgs.userPackages
fi