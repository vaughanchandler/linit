# Linit

Ansible config for my computers. Should work on Debian-based distros, but only tested on Linux Mint 19.1 and 20.1.

Draws heavily from [LearnLinuxTV](https://github.com/LearnLinuxTV/personal_ansible_desktop_configs).

## Usage

General usage: `curl https://raw.githubusercontent.com/vaughanchandler/linit/develop/bootstrap.sh | bash -s -- -C develop [--tags <tags...>] [--diff] [--check]`

Typical home usage: `curl https://raw.githubusercontent.com/vaughanchandler/linit/develop/bootstrap.sh | bash -s -- -C develop --tags accounting,dev,devops,genealogy,network,packages,ufw_common,upgrade`

Typical work usage: `curl https://raw.githubusercontent.com/vaughanchandler/linit/develop/bootstrap.sh | bash -s -- -C develop --tags dev,devops,network,packages,sshd,ufw_common,upgrade`

Local testing: `ansible-playbook local.yml --ask-become-pass [--tags <tags...>] [--diff] [--check]`

### Top level tags

* `software` - Installs all software packages.
* `ssh` - Installs SSH public keys.
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
