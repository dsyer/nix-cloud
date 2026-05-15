#!/bin/bash

set -e

if [ $# -lt 2 ]; then
    echo "Usage $0 <user> <hostname-or-ip>"
    exit 1
fi

user=$1
remote=$2
shift

ssh-keygen -f ~/.ssh/known_hosts -R $remote

touch ~/.ssh/config
awk -v remote="$remote" -v user="$user" '
  /^Host /   { in_gcp = ($0 == "Host gcp"); if (in_gcp) found=1 }
  in_gcp && /^[[:space:]]*HostName / { $0 = "  HostName " remote }
  in_gcp && /^[[:space:]]*User /     { $0 = "  User " user }
  { print }
  END { if (!found) printf "\nHost gcp\n    HostName %s\n    User %s\n    IdentityFile ~/.ssh/google_compute_engine\n", remote, user }
' ~/.ssh/config > ~/.ssh/config.tmp && mv ~/.ssh/config.tmp ~/.ssh/config

while ! ssh -o StrictHostKeyChecking=no gcp mkdir -m 700 -p .ssh
do
    echo "Waiting for ssh..."
    ((c++)) && ((c==10)) && break
    sleep 1
done

# Use git to rsync the files, which works more reliably on windows
ssh -o StrictHostKeyChecking=no gcp sudo apt -y install git git-hub
ssh -o StrictHostKeyChecking=no gcp 'mkdir -p ~/nix-cloud && cd ~/nix-cloud && git init'
git remote add gcp gcp:~/nix-cloud || echo "Remote already exists"
git push gcp main --force
ssh -o StrictHostKeyChecking=no gcp 'cd nix-cloud && git checkout main'

ssh -o StrictHostKeyChecking=no gcp nix-cloud/scripts/init.sh