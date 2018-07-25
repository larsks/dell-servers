## Requirements

To run the playbooks:

- Ansible

To generate the 'hosts' file:

- Ansible
- [xq][]

[xq]: https://github.com/kislyuk/yq

## Cookbook

### Get system information for all systems

    ansible idrac -m raw -a 'racadm getsysinfo'

### Get system information for a single system

    ansible 10.0.3.1 -m raw -a 'racadm getsysinfo'

### Get firmware version information for all systems

    ansible idrac -m raw -a 'racadm getversion'

## Playbooks

- `get-firmware-versions.yml`

  This playbook produces a report in `data/firmware-versions.txt`
  containing the BIOS and iDRAC versions for each host.

- `update-idrac.yml`

  This playbook will upgrade the target iDRAC(s) if the current
  firmware is not the expected value.

  Note that the firmware upgrade process can take a few minutes,
  during which you will not see any output from Ansible.

  The iDRAC uses ftp to fetch the firmware image.  There are default
  credentials and paths in the playbook; you can override them by
  setting:

  - `ftp_server` -- hostname or address of the ftp server
  - `ftp_user`, `ftp_pass`, -- credentials for authenticating with the
    ftp server
  - `firmware_path` -- path to the firmware image on the ftp server

- `update-bios.yml`

  This playbook will upgrade the system BIOS firmware if it is
  not the expected value.

  The BIOS upgrade process requires a server reboot.  If the RAID
  controller on a target server is not properly configured, the server
  will require manual intervention to respond to the error displayed
  on screen.
