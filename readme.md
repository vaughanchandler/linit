# Linit

Ansible config for my computers.

Draws from [LearnLinuxTV](https://github.com/LearnLinuxTV/personal_ansible_desktop_configs).

## Supported Systems

* Linux Mint 22 with Cinnamon: fully supported.
* Linux Mint 20 and 21 with Cinnamon: probably fine but not tested recently.
* Pop!_OS 22.04 with Gnome: probably fine but not tested recently.
* Manjaro 20.2.1: your mileage may vary - some tags were tested successfully in the past; the install script and the upgrade tag are known to not work.

## Installation

1. Install git and clone the repo from `https://github.com/vaughanchandler/linit`, or download the files from GitHub using a web browser.
2. Run `./install.sh` from the root of the repo

The install script installs:

* Python's venv and pip modules (globally).
* The ansible package into a venv virtual environment (including the required ansible.posix and community.general collections).

## Usage

1. Activate the virtual environment: `source venv/bin/activate`
2. Run the playbook: `ansible-playbook local.yml --ask-become-pass [--tags <tags...>] [--diff] [--check]`

To complete Ulauncher setup (if the `packages` tag was used):

* Start Ulauncher.
* Run the playbook again with the `cinnamon,packages` tags.
* Restart Ulauncher.

### Common Tags

In a VM: `apparmor,bash,cinnamon,dconf,network,packages,ssh,sshd,upgrade`

At home: `accounting,apparmor,bash,cinnamon,data,dconf,dev,gaming,genealogy,media,network,notes,packages,swap,sync,ufw,ufw_syncthing,upgrade,vm`

At work: `apparmor,aws,bash,cinnamon,data,dconf,dev,dropbox,media,network,packages,ssh,sshd,swap,sync,ufw,ufw_syncthing,upgrade,vm`

### Variables

You can use the -e argument from the CLI to override certain variables, eg:

* To set your name and email in git, set the `full_name` and `email` variables: `-e '{"full_name":"My Name", "email":"me@example.com"}'`
* To control which IPs can access your system , set the `trusted_ips` variable: `-e '{"trusted_ips":["192.168.42.0/24"]}'` (see ufw.yml for port details)
* To add your SSH key instead of mine, set the `public_keys` variable: `-e '{"public_keys":"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICjFyT2DFqAVUXQ0CVqjct2B7UBGOSMBJtvRmUVZGPA9 me@example.com"}'`

### Primary tags

* `apparmor` - Enables apparmor profiles.
* `bash` - Configures bash.
* `data` - Configures the data partition and symlinks to it from the home folder.
* `dconf` - Configures system settings (needs a DE tag like `cinnamon` or `gnome`).
* `software` - Installs all software packages.
* `ssh` - Installs SSH public keys.
* `swap` - Creates and enables a swap file on the root partition.
* `ufw` - Enables UFW to manage iptables without inbound rules.
* `upgrade` - Upgrades all installed packages.

### Additional tags

These tags represent categories that are basically subsets of the `software` tag:

* `accounting` - Installs HomeBank.
* `aws` - Install the AWS CLI.
* `dev` - Installs useful development packages.
* `gaming` - Installs Steam, Lutris and PCSX2 (only tested on Pop!_OS).
* `genealogy` - Installs Gramps and libraries it uses.
* `media` - Installs useful audio/video packages.
* `notes` - Installs Joplin.
* `network` - Installs useful networking packages.
* `packages` - Installs general packages that don't fall into another group.
* `pentest` - Installs useful penetration testing packages (you'll probably want the `network` tag also).
* `sshd` - Installs OpenSSH server.
* `sync` - Installs Syncthing.
* `vm` - Installs Vagrant and VirtualBox.

There are also tags for individual pieces of software that have their own tasks:

* `barrier`
* `docker`
* `dropbox`
* `git`
* `google_chrome`
* `homebank`
* `joplin`
* `keepassxc`
* `kismet`
* `precommit`
* `qbittorrent`
* `solaar`
* `sublimetext`
* `syncthing`
* `ulauncher`
* `unetbootin`
* `vagrant`
* `veracrypt`
* `virtualbox`
* `vscode`

These tags can be used for allowing inbound traffic through the firewall (`ufw` must still be used to enable UFW, and you'll probably want to set `trusted_ips` appropriately):

* `ufw_barrier` - Allows TCP 24800 for Barrier.
* `ufw_dns` - Allows UDP 53 for DNS.
* `ufw_dropbox` - Allows TCP/UDP 17500 for Dropbox.
* `ufw_http` - Allows TCP 80 for HTTP.
* `ufw_https` - Allows TCP 443 for HTTPS.
* `ufw_mysql` - Allows TCP 3306 for MySQL.
* `ufw_postgres` - Allows TCP 5432 for PostgreSQL.
* `ufw_sshd` - Allows TCP 22 for SSH.
* `ufw_syncthing` - Allows TCP/UDP 22000 and UDP 21027 for Syncthing.
* `ufw_warpinator` - Allows TCP/UDP 42000 for Warpinator.

The `cinnamon` and `gnome` tags enable tasks which can only be performed in the Cinnamon and Gnome desktop environments respectively. These tasks may perform additional configuration related to primary tasks (eg autostarting an application), or may just carry out general desktop configuration.

The `swap1` tag creates a 1GB swap file when specified on its own or with the `swap` tag, whereas the `swap` tag calculates a swap size based on Ubuntu's minimum recommendations: the square root of the total RAM in GB rounded up to the nearest 1GB, eg 4GB for a system with 16GB RAM. If you want the filesize re-calculated after running with a different tag or if you have a different amount of RAM, you'll first need to run `swapoff -a` to free /swapfile and then delete it.

## Troubleshooting

If the git settings aren't working, you may be affected by a bug which wraps the setting values in quotes. Edit /etc/gitconfig and remove the relevant quotes.

If dconf settings aren't working, you may be affected by a bug which prevents new keys from being created. Download an updated copy of [dconf.py](https://raw.githubusercontent.com/jikamens/community.general/a37589cebd5d6ca1b0e1ea963c0ed26eb5019f7b/plugins/modules/dconf.py) and put it in a new `library` folder in the root of this repo, then run the playbook again.

## Development

To monitor dconf changes, run `dconf watch /`. You can also specify a more specific path to limit output.
