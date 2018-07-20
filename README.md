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
