default['cups']['default_printer'] = nil
default['cups']['hostname_lookups'] = false
default['cups']['loglevel'] = 'info'
default['cups']['printers'] = []
# a data bag to read printer configuration from:
default['cups']['printer_bag'] = nil
default['cups']['systemgroups'] = 'sys root'
default['cups']['ports'] = [631]
default['cups']['require_encryption'] = false
default['cups']['cert_file'] = nil
default['cups']['key_file'] = nil

# ACLs for printer access:
default['cups']['share_printers'] = ['@LOCAL']

# ACLs like '.example.com' need DNS lookups
default['cups']['hostname_lookups'] = false

# allowed HTTP Host: headers
default['cups']['server_aliases'] = []

# ACLs for remote administration -- default is localhost only
default['cups']['admin']['acl'] = []

# whether authentication is required for read-only access to the web-interface:
# Should be enabled as soon as remote admin access is granted
default['cups']['admin']['auth_read'] = false

# specify whether authentication is required to access the website and printers
default['cups']['require_authentication'] = false
