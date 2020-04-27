#!/bin/bash -x

if [ $# -lt 1 ]; then
    echo "Usage $0 <hostname-or-ip>"
    exit 1
fi

remote=$1
shift

ssh-keygen -f ~/.ssh/known_hosts -R $remote
ssh -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine $remote mkdir -m 700 -p .ssh
ssh -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine $remote test -e ~/.ssh/id_rsa || scp -i ~/.ssh/google_compute_engine -o StrictHostKeyChecking=no ~/.ssh/id_rsa $remote:~/.ssh

rsync -e 'ssh -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine' --filter=':- .gitignore' -a -P . $remote:~/nix-cloud

ssh -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine $remote ~/nix-cloud/scripts/init.sh