default['cups']['default_printer'] = nil
default['cups']['hostname_lookups'] = false
default['cups']['loglevel'] = 'info'
default['cups']['printers'] = []
default['cups']['systemgroups'] = "sys root"
# ACLs for printer access:
default['cups']['share_printers'] = [ '@LOCAL' ]
# ACLs for remote administration -- default is localhost only
default['cups']['admin']['acl'] = [ ]
# wether authentication is required for read-only access to the web-interface:
# Should be enabled as soon as remote admin access is granted
default['cups']['admin']['auth_read'] = false
default['cups']['airprint']['airprint_generate']['git_url'] = 'https://github.com/tjfontaine/airprint-generate.git'
default['cups']['airprint']['airprint_generate']['git_revision'] = 'master'
