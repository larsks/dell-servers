all: hosts

# This uses nmap to translate the address ranges in the idrac.ranges file
# into a list of individual addresses.
data/idrac.json: idrac.ranges
	nmap -sL -n -oX - -iL $< | xq . > $@ || rm -f $@

# This translates the nmap output into an Ansible inventory.
hosts: data/idrac.json templates/hosts.in
	ansible-playbook generate-idrac-inventory.yml
	touch $@

# Remove generated files.
clean:
	rm -f hosts data/idrac.json
