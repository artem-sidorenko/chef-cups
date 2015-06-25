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
printers = lpstatcmd.stdout.split(/\n/)
printers.map! do |x|
  phash = {}
  phash['name'] = x.gsub(/^device\sfor\s/, '').gsub(/:\s.*/, '')
  phash['uri'] = x.gsub(/^.*:\s/, '')
  phash
end

oldprinters = []

printers.each do |px|
  oldprinters << px['name']
end

# turn the printer array of hashes into a single hash:
newprinters = node['cups']['printers'].inject({}) do |result,hash|
  printer = hash.first
  result[printer[0]] = printer[1]
  result
end

newprinters.each do |name,config|
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
  if config['location']
    cmdline << " -L \"#{config['location']}\""
  end
  if config['desc']
    cmdline << " -D \"#{config['desc']}\""
  end
  if oldprinters.include?(name)
    printers.each do |oldprinterhash|
      next if oldprinterhash['name'] != name
      next if oldprinterhash['uri'] == config['uri']
      execute cmdline
    end
  else
    execute cmdline
  end
end
