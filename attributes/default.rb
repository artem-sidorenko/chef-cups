default['cups']['default_printer'] = nil
default['cups']['hostname_lookups'] = false
default['cups']['loglevel'] = 'info'
default['cups']['printers'] = []
# a data bag to read printer configuration from:
default['cups']['printer_bag'] = nil
default['cups']['systemgroups'] = 'sys root'
default['cups']['ports'] = [ 631 ]
default['cups']['require_encryption'] = false
default['cups']['certificate']['data_bag'] = nil
default['cups']['certificate']['data_bag_type'] = 'unencrypted'
default['cups']['certificate']['search_id'] = 'cups'
default['cups']['certificate']['cert_file'] = "#{node['fqdn']}.pem"
default['cups']['certificate']['key_file'] = "#{node['fqdn']}.key"
default['cups']['certificate']['chain_file'] = "#{node['hostname']}-bundle.crt"
default['cups']['certificate']['cert_path'] = '/etc/cups/ssl'

# ACLs for printer access:
default['cups']['share_printers'] = [ '@LOCAL' ]

# ACLs like '.example.com' need DNS lookups
default['cups']['hostname_lookups'] = false

# ACLs for remote administration -- default is localhost only
default['cups']['admin']['acl'] = [ ]

# whether authentication is required for read-only access to the web-interface:
# Should be enabled as soon as remote admin access is granted
default['cups']['admin']['auth_read'] = false

default['cups']['airprint']['airprint_generate']['git_url'] = 'https://github.com/tjfontaine/airprint-generate.git'
default['cups']['airprint']['airprint_generate']['git_revision'] = 'master'
