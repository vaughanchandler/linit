# Linit

Ansible config for my computers. Should work on Debian-based distros, but only tested on Linux Mint 20 and 21 (and only recently on 21).

Draws from [LearnLinuxTV](https://github.com/LearnLinuxTV/personal_ansible_desktop_configs).

## Requirements

Git and Ansible must be installed, as well as Ansible's ansible.posix and community.general collections. The bootstrap script installs all of these.

To use a more recent version of Ansible from a PPA, you may need to remove the ansible package and install the ansible-core package: `apt -y remove ansible && apt -y install ansible-core`.

## Usage

If you already have git and ansible installed, along with the required Ansible collections, you can clone the repo from `https://github.com/vaughanchandler/linit` and run `ansible-playbook local.yml --ask-become-pass [--tags <tags...>] [--diff] [--check]` from the develop branch.

If not, you can run the bootstrap script to get up and running: `curl https://raw.githubusercontent.com/vaughanchandler/linit/develop/bootstrap.sh | bash -s -- -C develop [--tags <tags...>] [--diff] [--check]`

To complete Ulauncher setup (if the `packages` tag was used):

* Start Ulauncher.
* `curl https://raw.githubusercontent.com/vaughanchandler/linit/develop/bootstrap.sh | bash -s -- -C develop --tags cinnamon,packages`
* Restart Ulauncher.

### Common Tags

In a VM: `apparmor,bash,cinnamon,dconf,network,packages,ssh,sshd,upgrade`

At home: `accounting,ansible_ppa,apparmor,bash,cinnamon,data,dconf,dev,gaming,genealogy,media,network,packages,swap,sync,ufw_common,ufw_syncthing,upgrade,vm`

At work: `ansible_ppa,apparmor,bash,cinnamon,data,dconf,dev,media,network,packages,ssh,sshd,swap,sync,ufw_common,ufw_syncthing,upgrade,vm`

### Variables

You can use the -e argument from the CLI to override certain variables, eg:

* To set your name and email in git, set the `full_name` and `email` variables: `-e '{"full_name":"My Name", "email":"me@example.com"}'`
* To control which IPs can access your system , set the `trusted_ips` variable: `-e '{"trusted_ips":["192.168.42.0/24"]}'` (see ufw.yaml for port details)
* To add your SSH key instead of mine, set the `public_keys` variable: `-e '{"public_keys":"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEZRKnL68aPgv2XOw8iI+LjGbDZ3dU/0E8GcLdsyhGo vaughan.codes@gmail.com"}'`

### Testing

Local testing: `ansible-playbook local.yml --ask-become-pass [--tags <tags...>] [--diff] [--check]`

### Top level tags

* `apparmor` - Enables apparmor profiles.
* `bash` - Configures bash.
* `data` - Configures the data partition and symlinks to it from the home folder.
* `dconf` - Configures system settings (needs a DE tag like `cinnamon` or `gnome`).
* `software` - Installs all software packages.
* `ssh` - Installs SSH public keys.
* `swap` - Creates and enables a swap file on the root partition.
* `ufw` - Enables UFW to manage iptables without inbound rules.
* `ufw_common` - Enables UFW to manage iptables with common inbound rules.
* `upgrade` - Upgrades all installed packages.

### Second level tags

These tags are subsets of the `software` tag:

* `accounting` - Installs HomeBank.
* `ansible_ppa` - Installs Ansible's PPA (on some distros you may need to run `apt -y remove ansible && apt -y install ansible-core` after installing the PPA to get the latest version of Ansible installed).
* `dev` - Installs useful development packages.
* `gaming` - Installs Steam, Lutris and PCSX2 (only tested on Pop!_OS).
* `genealogy` - Installs Gramps and libraries it uses.
* `media` - Installs useful audio/video packages.
* `network` - Installs useful networking packages.
* `packages` - Installs general packages that don't fall into another group.
* `pentest` - Installs useful penetration testing packages (you'll probably want the `network` tag also).
* `sshd` - Installs OpenSSH server.
* `sync` - Installs Syncthing.
* `vm` - Installs Vagrant and VirtualBox.

These tags can be used for allowing inbound traffic through the firewall (`ufw` or `ufw_common` must still be used to enable UFW):

* `ufw_barrier` - Allows TCP 24800 for Barrier.
* `ufw_dns` - Allows UDP 53 for DNS.
* `ufw_dropbox` - Allows TCP/UDP 17500 for Dropbox (included in `ufw_common`).
* `ufw_http` - Allows TCP 80 for HTTP.
* `ufw_https` - Allows TCP 443 for HTTPS.
* `ufw_mysql` - Allows TCP 3306 for MySQL.
* `ufw_postgres` - Allows TCP 5432 for PostgreSQL.
* `ufw_sshd` - Allows TCP 22 for SSH (included in `ufw_common`).
* `ufw_syncthing` - Allows TCP/UDP 22000 and UDP 21027 for Syncthing.
* `ufw_warpinator` - Allows TCP/UDP 42000 for Warpinator (included in `ufw_common` for Linux Mint only).

### Other tags

The `cinnamon` and `gnome` tags enable tasks which can only be performed in the Cinnamon and Gnome desktop environments respectively. These tasks may perform additional configuration related to primary tasks (eg autostarting an application), or may just carry out general desktop configuration.

The `swap1` tag creates a 1GB swap file when specified on its own or with the `swap` tag, whereas the `swap` tag calculates a swap size based on Ubuntu's minimum recommendations: the square root of the total RAM in GB rounded up to the nearest 1GB, eg 4GB for a system with 16GB RAM. If you want the filesize re-calculated after running with a different tag or if you have a different amount of RAM, you'll first need to run `swapoff -a` to free /swapfile and then delete it.

## Manjaro support

Some tags were tested successfully with Manjaro 20.2.1 using an older version of Linit. The upgrade tag is known to not work.

# Troubleshooting

If the git settings aren't working, you may be affected by a bug which wraps the setting values in quotes. Edit /etc/gitconfig and remove the relevant quotes.
