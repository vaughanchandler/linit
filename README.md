# Linit

Ansible config for my computers. Should work on Debian-based distros, but only tested on Linux Mint 19.1 and 20.1.

Draws heavily from [LearnLinuxTV](https://github.com/LearnLinuxTV/personal_ansible_desktop_configs).

## Usage

General usage: `curl https://raw.githubusercontent.com/vaughanchandler/linit/develop/bootstrap.sh | bash -s -- -C develop [--tags <tags...>] [--diff] [--check]`

Typical vm usage: `curl https://raw.githubusercontent.com/vaughanchandler/linit/develop/bootstrap.sh | bash -s -- -C develop --tags cinnamon,dconf,network,packages,ssh,sshd,upgrade`

Typical home usage: `curl https://raw.githubusercontent.com/vaughanchandler/linit/develop/bootstrap.sh | bash -s -- -C develop --tags accounting,cinnamon,dconf,dev,devops,genealogy,network,packages,swap,ufw_common,upgrade`

Typical work usage: `curl https://raw.githubusercontent.com/vaughanchandler/linit/develop/bootstrap.sh | bash -s -- -C develop --tags cinnamon,dconf,dev,devops,network,packages,ssh,sshd,swap,ufw_common,upgrade`

To complete Ulauncher setup (if the `packages` tag was used):

* Start Ulauncher.
* `curl https://raw.githubusercontent.com/vaughanchandler/linit/develop/bootstrap.sh | bash -s -- -C develop --tags cinnamon,packages`
* Restart Ulauncher.

### Testing

Local testing: `ansible-playbook local.yml --ask-become-pass [--tags <tags...>] [--diff] [--check]`

### Top level tags

* `dconf` - Configures system settings (needs a DE tag like `cinnamon`).
* `software` - Installs all software packages.
* `ssh` - Installs SSH public keys.
* `swap` - Creates and enables a swap file on the root partition.
* `ufw` - Enables UFW to manage iptables without inbound rules.
* `ufw_common` - Enables UFW to manage iptables with common inbound rules.
* `upgrade` - Upgrades all installed packages.

### Second level tags

These tags are subsets of the `software` tag:

* `accounting` - Installs HomeBank.
* `dev` - Installs useful development packages.
* `devops` - Installs useful devops packages.
* `genealogy` - Installs Gramps and libraries it uses.
* `network` - Installs useful networking packages.
* `packages` - Installs general packages that don't fall into another group.
* `pentest` - Installs useful penetration testing packages.
* `sshd` - Installs OpenSSH server.

These tags can be used for allowing inbound traffic through the firewall (`ufw` or `ufw_common` must still be used to enable UFW):

* `ufw_barrier` - Allows TCP 24800 for Barrier.
* `ufw_dns` - Allows UDP 53 for DNS.
* `ufw_dropbox` - Allows TCP/UDP 17500 for Dropbox (included in `ufw_common`).
* `ufw_http` - Allows TCP 80 for HTTP.
* `ufw_https` - Allows TCP 443 for HTTPS.
* `ufw_mysql` - Allows TCP 3306 for MySQL.
* `ufw_postgres` - Allows TCP 5432 for PostgreSQL.
* `ufw_sshd` - Allows TCP 22 for SSH (included in `ufw_common`).
* `ufw_warpinator` - Allows TCP/UDP 42000 for Warpinator (included in `ufw_common` for Linux Mint only).

### Other tags

The `cinnamon` tag enables tasks which can only be performed in the Cinnamon desktop environment. These tasks may perform additional configuration related to primary tasks (eg autostarting an application), or may just carry out general desktop configuration.

The `swap1` tag creates a 1GB swap file when specified on its own or with the `swap` tag, whereas the `swap` tag calculates a swap size based on Ubuntu's minimum recommendations: the square root of the total RAM in GB rounded up to the nearest 1GB, eg 4GB for a system with 16GB RAM.
