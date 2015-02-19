name             'cups'
maintainer       'Biola University'
maintainer_email 'jim.reeves@biola.edu'
license          'Apache 2.0'
description      'Installs/Configures cups'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/biola/chef-cups'
issues_url       'https://github.com/biola/chef-cups/issues'
version          '0.4.1'

#depends 'git', '~> 4.0'

%w(ubuntu debian redhat centos amazon scientific smartos).each do |os|
  supports os
end
