#!/usr/bin/env bash

set -e

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -d venv ]; then
    echo -e "\nRemoving current venv"
    rm -rf venv
fi

apt_packages=()
for package in python3-pip python3-venv; do
    dpkg -s "$package" > /dev/null 2>&1 || {
        apt_packages+=("$package")
    }
done

if [ ${#apt_packages[@]} -gt 0 ]; then
    echo -e "\nInstalling ${apt_packages[*]}"
    sudo apt-get update
    sudo apt-get install -y "${apt_packages[@]}"
fi

echo -e "\nCreating venv"
python3 -m venv venv

echo -e "\nInstalling requirements"
source venv/bin/activate
pip install -r requirements.txt

echo -e "\nDone"

