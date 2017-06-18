printers = %w[vagrantprinter1 vagrantprinter2]

# avahi-browse delivers empty result first time, so we have to call it twice
describe command('avahi-browse -a -t') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
end

describe command('avahi-browse -a -t') do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq '' }
  printers.each do |prt|
    its(:stdout) { should match(/.*IPv4 AirPrint #{prt} @ .* Internet Printer .* local/) }
  end
end
