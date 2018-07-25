# How to access the iDRAC management interface

## Getting access to the iDRAC network

### Using sshuttle

If you are not directly connected to the iDRAC network, the easiest
way to get access is through use of the [sshuttle][] command.  You
would use it something like this:

    sshuttle -D -r kzn-h.infra.massopen.cloud 10.0.0.0/16

This allows you to directly access systems on the 10.0.0.0/16 network
as if your local system was directly connected to that network.

[sshuttle]: https://github.com/sshuttle/sshuttle

### Setting up an SSH proxyhost

You can configure `ssh` to proxy connections through `kzn-h` by adding
the following to your `~/.ssh/config` file:

    Host 10.0.*
      ProxyCommand ssh kzn-h.infra.massopen.cloud -W %h:%p

This will allow you to ssh to the iDRACs as if you were directly on
the iDRAC network.

### Setting up an SSH SOCKS proxy

If you want to use your web browser to interact with the iDRAC web
UI, you can set up a SOCKS5 proxy using ssh like this:

    ssh -D 1080 kzn-h.infra.massopen.cloud

This creates a SOCKS5 proxy on port 1080 on your local system.  If you
configure your browser to use that proxy, you will be able to access
the iDRAC web interfaces.

## Connecting to the iDRAC

## SSH Access

You can access the iDRAC management interface using ssh.  The username
and password are the same ones you use to log in with the web UI.
You can use the `sshpass` program if you'd like to automate ssh
commands without entering a password every time.  For example:

    sshpass -ppassword ssh root@10.0.3.1 racadm help

Or you can just connect to an interactive session:

    ssh root@10.0.3.1

## Using Ansible

This repository includes script for generating an Ansible inventory
containing all the iDRAC hosts.  From the directory containing the
`ansible.cfg` and `hosts` files, you can run ad-hoc commands like
this:

    ansible 10.0.3.1 -m raw -a 'racadm getniccfg'

Note that you can *only* use the `raw` module when running tasks
against the iDRACs (this module is effectively a thin wrapper around
`ssh <somehost> command`).

You can also run Ansible playbooks against the iDRACs.  For example,
the following would collect the output of `racadm getsysinfo`:

```yaml
---
- hosts: idrac
  tasks:
    - name: get system info
      raw: racadm getsysinfo
      register: sysinfo

    - name: ensure output directory exists
      delegate_to: localhost
      file:
        path: ./sysinfo
        state: directory

    - name: write system info to a file
      delegate_to: localhost
      copy:
        content: "{{ sysinfo.stdout }}"
        dest: "./sysinfo/{{ inventory_hostname }}.txt"
```

You could run it against all iDRACs like this:

    ansible-playbook get-sysinfo.yml

Or against specific iDRACs like this:

    ansible-playbook get-sysinfo.yml -l 10.0.3.1

Running this playbook would produce a collection of files in
`./sysinfo` containing the output of `racadm getsysinfo` on each
iDRAC.

## VNC console access

If the iDRAC is running a recent firmware *and* if the iDRAC has been
correctly configured, you can use a generic VNC client to access the
system console.  This is often much more convenient then Dell's
proprietary console access tool.

See [Enabling VNC console access](vnc-console.md) for more
information.

## REST API

If the iDRAC is running a recent firmware, you also can interact with
the iDRAC using a REST API.  See [Interacting with the Redfish REST
API](redfish.md) for more information.
