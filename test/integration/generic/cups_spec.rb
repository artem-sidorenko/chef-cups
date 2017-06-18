describe service('cups') do
  it { should be_running }
  it { should be_enabled }
end

# Verify the printers are configured properly
describe command('lpstat -v') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
  its(:stdout) do
    should include 'device for vagrantprinter1: lpd://192.168.10.5'
    should include 'device for vagrantprinter2: lpd://192.168.10.6'
  end
end
