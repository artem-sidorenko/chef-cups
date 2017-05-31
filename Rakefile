# Heavily based on https://github.com/dev-sec/chef-ssh-hardening/blob/master/Rakefile

# rubocop:disable Style/SymbolArray

require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'chef/cookbook/metadata'

desc 'Run all tests except Kitchen (default task)'
task default: [:lint, :spec]

desc 'Run all linters: rubocop and foodcritic'
task lint: [:rubocop, :foodcritic]

desc 'Run all tests'
task test: [:lint, :kitchen, :spec]

desc 'Run chefspec tests'
task :spec do
  puts 'Running Chefspec tests'
  RSpec::Core::RakeTask.new(:spec)
end

desc 'Run foodcritic lint checks'
task :foodcritic do
  puts 'Running Foodcritic tests...'
  FoodCritic::Rake::LintTask.new do |t|
    t.options = { fail_tags: ['any'] }
    puts 'done.'
  end
end

desc 'Run Rubocop lint checks'
task :rubocop do
  RuboCop::RakeTask.new
end

desc 'Run kitchen integration tests'
task :kitchen do
  concurrency = ENV['CONCURRENCY'] || 1
  instance = ENV['INSTANCE'] || ''
  sh('sh', '-c', "bundle exec kitchen test -c #{concurrency} #{instance}")
end

# Automatically generate a changelog for this project. Only loaded if
# the necessary gem is installed.
begin
  # read version from metadata
  metadata = Chef::Cookbook::Metadata.new
  metadata.instance_eval(File.read('metadata.rb'))

  # build changelog
  require 'github_changelog_generator/task'
  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    config.future_release = "v#{metadata.version}"
    config.user = 'artem-sidorenko'
    config.project = 'chef-cups'
  end
rescue LoadError
  puts '>>>>> GitHub Changelog Generator not loaded, omitting tasks'
end
