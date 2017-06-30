name             'cups'
maintainer       'Artem Sidorenko'
maintainer_email 'artem@posteo.de'
license          'Apache-2.0'
description      'Installs/Configures cups'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/artem-sidorenko/chef-cups'
issues_url       'https://github.com/artem-sidorenko/chef-cups/issues'
version          '0.11.0'

chef_version '>= 12.5' if respond_to?(:chef_version)

%w[ubuntu debian redhat centos amazon scientific smartos].each do |os|
  supports os
end
