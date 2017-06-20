printers = %w[vagrantprinter1 vagrantprinter2]

describe service('cups') do
  it { should be_running }
  it { should be_enabled }
end

# Verify the printers are configured properly
describe command('lpstat -v') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
  printers.each do |prt|
    its(:stdout) { should include "device for #{prt}: lpd://192.168.10" }
  end
end
