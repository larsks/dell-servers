#!/usr/bin/python


class FilterModule(object):
    def filter_ipsort(self, value):
        '''sort a dictionary with ipaddress keys into (key, value) pairs'''
        return sorted(value.items(),
                      key=lambda host: tuple(int(x)
                                             for x in host[0].split('.')))

    def filters(self):
        return {
            'ipsort': self.filter_ipsort,
        }
