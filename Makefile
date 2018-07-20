all: hosts

idrac.json: idrac.ranges
	nmap -sL -n -oX - -iL $< | xq . > $@ || rm -f $@

hosts: idrac.json
	ansible-playbook generate-idrac-inventory.yml
	touch $@
