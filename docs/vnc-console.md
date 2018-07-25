# Enabling VNC console access

Recent versions of the iDRAC firmware allow you to access the system
console using any standard VNC client, rather than Dell's proprietary
Java client.  This has a number of advantages:

- Running the java client requires a functional Java installation
- The java client was sensitive to JRE versions and security policies
  in ways that could make it difficult to run
- Standard vnc clients offer command line options that make them more
  compatible with simple task automation (such as opening consoles to
  a group of servers in a single command).

## Enabling VNC console using the web UI

After logging into the iDRAC web interface:

- Open the *iDRAC settings* menu and select *Network*
- Select the *Services* tab along the top of the screen
- Scroll to the bottom (or select the *VNC Server* option from the
  navigation menu).
- Check the *Enable VNC Server* checkbox
- Set a VNC password
- Select the *Apply* button.

## Enabling VNC console access using racadm

Connect to the iDRAC using `ssh` and run the following commands:

    racadm set idrac.vncserver.enable Enabled
    racadm set idrac.vncserver.Password yourpassword

## Enabling VNC console access using Ansible

You can take advantage of Ansible to automate this process on multiple
iDRACs.  The following playbook would enable VNC console access on all
servers in the `idrac` host group:

```yaml
---
# This playbook uses the racadm command to enable native VNC console
# support on all systems in the idrac host group.
- hosts: idrac
  vars:
    # You can override this default by putting your own values in
    # group_vars/all.yml (or group_vars/idrac.yml).
    idrac_vnc_pass: calvin
  tasks:
    - name: enable vnc server
      raw: racadm set idrac.vncserver.enable Enabled

    - name: set vnc password
      raw: racadm set idrac.vncserver.Password {{ idrac_vnc_pass }}
```

Running the playbook like this would execute it against all known
iDRACs:

    ansible-playbook enable-vnc.yml

You can run it against specific iDRACs like this:

    ansible-playbook enable-vnc.yml -l 10.0.3.1
