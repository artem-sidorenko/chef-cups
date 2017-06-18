#
# Cookbook Name:: cups
# Recipe:: default
#
# Copyright 2015-2017, Biola University
# Copyright 2017, Artem Sidorenko
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
package 'cups'

template '/etc/cups/cupsd.conf' do
  owner 'root'
  group 'lp'
  mode '0640'
  notifies :restart, 'service[cups]'
end

service 'cups' do
  action %i[start enable]
end

# Work around the lack of a lpstat command during first convergence
lpstat = if File.exist?('/usr/bin/lpstat')
           'lpstat -v'
         else
           'true'
         end
lpstatcmd = Mixlib::ShellOut.new(lpstat)
lpstatcmd.run_command

# create a hash of configured printers
#
#  Hash[lpstatcmd.stdout.scan(/^device for (.*?):\s(.*)/)]
#  would also do the trick
#   but as { name => device } instead of { name => { 'uri' => device } }
#   the latter may be useful to add other info, eg. from lpoptions
printers = lpstatcmd.stdout.scan(
  /^device for (.*?):\s(.*)/
).each_with_object({}) do |a, h|
  h[a[0]] = { 'uri' => a[1] }
end

# turn the printer array of hashes into a single hash:
newprinters = node['cups']['printers'].each_with_object({}) do |hash, result|
  printer = hash.first
  result[printer[0]] = printer[1]
end

# Read more printers from databag:
if node['cups']['printer_bag']
  data_bag(node['cups']['printer_bag']).each do |name|
    # attribute-defined printers take precedence over databag-defined ones:
    next if newprinters[name]

    # TODO: Add some method for filtering here?
    #  A regex for name matching? A special data bag attribute?
    newprinters[name] = data_bag_item(node['cups']['printer_bag'], name)
  end
end

newprinters.each do |name, config|
  # name is the printer name
  cmdline = ['lpadmin', '-p', name, '-E', '-v', config['uri']]

  if config['model']
    cmdline.concat ['-m', config['model']]
  elsif node['platform_family'] == 'debian' ||
        (node['platform_family'] == 'rhel' && node['platform_version'].to_f >= 7)
    cmdline.concat ['-m', 'lsb/usr/cupsfilters/textonly.ppd']
  else
    cmdline.concat ['-m', 'textonly.ppd']
  end

  cmdline.concat ['-L', config['location']] if config['location']

  cmdline.concat ['-D', config['desc']] if config['desc']

  execute "configure_printer_#{name}" do
    command cmdline
    # do nothing if the printer already exists and the device is unchanged:
    not_if { printers.key?(name) && printers[name]['uri'] == config['uri'] }
  end
end
