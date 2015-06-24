default['cups']['default_printer'] = nil
default['cups']['printers'] = []
default['cups']['systemgroups'] = "sys root"
default['cups']['ports'] = [ 631 ]
default['cups']['share_printers'] = [ '@LOCAL' ]
# ACLs like '.example.com' need DNS lookups
default['cups']['hostname_lookups'] = false
default['cups']['airprint']['airprint_generate']['git_url'] = 'https://github.com/tjfontaine/airprint-generate.git'
default['cups']['airprint']['airprint_generate']['git_revision'] = 'master'
