all: hosts

data/idrac.json: idrac.ranges
	nmap -sL -n -oX - -iL $< | xq . > $@ || rm -f $@

hosts: data/idrac.json templates/hosts.in
	ansible-playbook generate-idrac-inventory.yml
	touch $@

clean:
	rm -f hosts data/idrac.json
