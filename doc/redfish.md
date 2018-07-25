# Interacting with the Redfish REST API

[Redfish][] is an industry-standard REST API for managing servers.
Recent iDRAC firmware versions include Redfish support. This offers
substantial advantages over older management protocols (like IPMI or
racadm-over-ssh) because it provides *structured* access to
information. That is, instead of trying to parse output that was
designed primarily for human consumption (like the output of `racadm
getsysinfo`), you can request information in machine-readable format.
Instead of using proprietary protocols or specific tooling, you can
use any language or tool capable of making http requests.

[redfish]: https://www.dmtf.org/standards/redfish

## Online resources

- http://en.community.dell.com/techcenter/extras/m/white_papers/20443207

  This is Dell's whitepaper on using the Redfish API and Python
  scripting to manage your servers. It's an excellent resource with
  lots of practical examples.

- https://github.com/dell/iDRAC-Redfish-Scripting

  This is a repository of Python scripts (and Powershell scripts) that
  interact with the Redfish API.

- https://github.com/dell/redfish-ansible-module

  This is an Ansible module for interacting with the Redfish API.

## Some notes about the API

The Redfish API returns JSON results.  When you make a request against
an endpoint, the request may include both literal data, such as:

```json
{
  "BiosVersion": "2.7.0"
}
```

As well as *references* to additional data, as in:

```json
{
  "Storage": {
    "@odata.id": "/redfish/v1/Systems/System.Embedded.1/Storage"
  }
}
```

You will often need to follow a chain of references to find the data
you're looking for.

## Using curl to interact with the Redfish API

The `/redfish/v1/Systems/System.Embedded.1` endpoint has basic system
information.  We can use `curl` to fetch data from the API, and the
[`jq`][] command to execute queries against the returned JSON document.

[jq]: https://stedolan.github.io/jq/

For example, to get information about the available
memory on the system, you could run:

    curl -sk -u root:calvin \
      https://10.0.3.1/redfish/v1/Systems/System.Embedded.1 |
      jq '.MemorySummary'

And get back:

```json
{
  "Status": {
    "Health": "OK",
    "HealthRollup": "OK",
    "State": "Enabled"
  },
  "TotalSystemMemoryGiB": 119.209344
}
```

If we wanted *just* the total memory (maybe we want the value for a
script), we could rewrite our query to be:

    jq -r '.MemorySummary.TotalSystemMemoryGib'

## Using Ansible's uri module to interact with the Redfish API

Ansible's URI module can be used to make http requests and record the
content into a variable for further processing.  This is a convenient
way to handle situations in which you need to make several requests to
find the information you want.  The following playbook will report the
number of drives attached to a host:

```yaml
---
- hosts: idrac
  vars:
    idrac_user: root
    idrac_pass: calvin
  tasks:
    - name: get system info
      delegate_to: localhost
      uri:
        url: "https://{{ inventory_hostname }}/redfish/v1/Systems/System.Embedded.1"
        user: "{{ idrac_user }}"
        password: "{{ idrac_pass }}"
        return_content: true
        validate_certs: false
      register: sysinfo

    - name: get list of storage controllers
      delegate_to: localhost
      uri:
        url: "https://{{ inventory_hostname }}{{ sysinfo.json.Storage['@odata.id'] }}"
        user: "{{ idrac_user }}"
        password: "{{ idrac_pass }}"
        return_content: true
        validate_certs: false
      register: storage

    - name: get information about first storage controller
      delegate_to: localhost
      uri:
        url: "https://{{ inventory_hostname }}{{ storage.json.Members.0['@odata.id'] }}"
        user: "{{ idrac_user }}"
        password: "{{ idrac_pass }}"
        return_content: true
        validate_certs: false
      register: storage0

    - debug:
        msg: "number of drives: {{ storage0.json.Drives|length }}"
```

This makes a request against the `/Systems/System.Embedded.1`
endpoint, the follows the reference from the `Storage` key, which
yields a list of RAID controllers, and then fetches information about
the first RAID controller and looks at the number of attached drives.
