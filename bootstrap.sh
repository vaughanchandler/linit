#!/bin/bash

# Usage ./bootstrap.sh [branch]

# Install git and ansible.
if ! command -v 'git' &>/dev/null || ! command -v 'ansible' &>/dev/null; then
    if command -v 'apt' &>/dev/null; then
        apt install -y git ansible
    else
        echo "No supported package manager found, please install git and ansible manually."
        exit 1
    fi
fi

# Install community.general collection (can't list installed collections in ansible < 2.10)
ansible-galaxy collection install community.general

# Run playbook, passing any CLI args this script received.
if [[ $EUID -eq 0 ]]; then
    become=
else
    become='--ask-become-pass'
fi
ansible-pull --url https://github.com/vaughanchandler/linit $become $@
