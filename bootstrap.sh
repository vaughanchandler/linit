#!/bin/bash

# Usage ./bootstrap.sh [branch]

# Install git and ansible.
if ! command -v 'git' &>/dev/null || ! command -v 'ansible' &>/dev/null; then
    if command -v 'apt' &>/dev/null; then
        echo "Installing git and/or ansible via apt, press ENTER to continue or CTRL+C to cancel."
        read
        apt install -y git ansible
    elif command -v 'pacman' &>/dev/null; then
        echo "Installing git and/or ansible via pacman, press ENTER to continue or CTRL+C to cancel."
        read
        sudo pacman -Sy --noconfirm git ansible
    else
        echo "No supported package manager found, please install git and ansible manually."
        exit 1
    fi
fi

# Install community.general collection (can't list installed collections in ansible < 2.10 so the install will be attempted on each run there).
if ! ansible-galaxy collection list 2>/dev/null | grep -q community.general; then
    ansible-galaxy collection install community.general
fi

# Run playbook, passing any CLI args this script received.
if [[ $EUID -eq 0 ]]; then
    become=
else
    become='--ask-become-pass'
fi
ansible-pull --url https://github.com/vaughanchandler/linit $become $@
