#!/bin/bash

set -e

if [ $# -lt 1 ]; then
    echo "Usage $0 (user@)<hostname-or-ip>"
    exit 1
fi

remote=$1
shift

ssh-keygen -f ~/.ssh/known_hosts -R $remote
while ! ssh -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine $remote mkdir -m 700 -p .ssh
do
    echo "Waiting for ssh..."
    ((c++)) && ((c==10)) && break
    sleep 1
done

# Use git to rsync the files, which works more reliably on windows
ssh -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine $remote dnf -y install git
ssh -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine $remote 'mkdir -p ~/nix-cloud && cd ~/nix-cloud && git init'
git remote add gcp gcp:~/nix-cloud
git push gcp main --force
ssh -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine $remote 'cd nix-cloud && git checkout main'

ssh -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine $remote nix-cloud/scripts/init.sh