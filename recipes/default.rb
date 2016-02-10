#
# Cookbook Name:: cups
# Recipe:: default
#
# Copyright 2015, Biola University
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

certificate_manage 'cups' do
  data_bag node['cups']['certificate']['data_bag']
  data_bag_type node['cups']['certificate']['data_bag_type']
  search_id node['cups']['certificate']['search_id']
  cert_file node['cups']['certificate']['cert_file']
  key_file node['cups']['certificate']['key_file']
  chain_file node['cups']['certificate']['chain_file']
  cert_path node['cups']['certificate']['cert_path']
  only_if { node['cups']['require_encryption'] == true }
end

template '/etc/cups/cupsd.conf' do
  owner 'root'
  group 'lp'
  mode '0640'
end

service 'cups' do
  pattern 'cupsd'
  supports restart: true, reload: false, status: true
  action :start
  subscribes :restart, 'template[/etc/cups/cupsd.conf]'
end

# Work around the lack of a lpstat command during first convergence
if File.exist?('/usr/bin/lpstat')
  lpstat = 'lpstat -v'
else
  lpstat = 'true'
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
  cmdline = "lpadmin -p #{name} -E "\
            "-v #{config['uri']}"
  if config['model']
    cmdline << " -m #{config['model']}"
  else
    if node['platform_family'] == 'debian'
      cmdline << ' -m lsb/usr/cupsfilters/textonly.ppd'
    else
      cmdline << ' -m textonly.ppd'
    end
  end

  cmdline << " -L \"#{config['location']}\"" if config['location']

  cmdline << " -D \"#{config['desc']}\"" if config['desc']

  execute cmdline do
    # do nothing if the printer already exists and the device is unchanged:
    not_if { printers.key?(name) && printers[name]['uri'] == config['uri'] }
  end
end
