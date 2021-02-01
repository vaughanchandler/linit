# Linit

Ansible config for my computers. Should work on Debian-based distros, but only tested on Linux Mint 19.1 and 20.1.

Draws heavily from [LearnLinuxTV](https://github.com/LearnLinuxTV/personal_ansible_desktop_configs).

## Usage

Local testing: `ansible-playbook local.yml --ask-become-pass [--tags <tags...>]`

Typical tags for home usage: `accounting,dev,devops,genealogy,network,packages,update`

Typical tags for work usage: `dev,devops,network,packages,update`

### Top level tags

* **software** - Installs all software packages.
* **upgrade** - Upgrades all installed packages.

### Second level tags

These tags are subsets of the **software** tag:

* **accounting** - Installs HomeBank.
* **dev** - Installs useful development packages.
* **devops** - Installs useful devops packages.
* **genealogy** - Installs Gramps and libraries it uses.
* **network** - Installs useful networking packages.
* **packages** - Installs general packages that don't fall into another group.
* **pentest** - Installs useful penetration testing packages.
* **ssh** - Installs OpenSSH server.
