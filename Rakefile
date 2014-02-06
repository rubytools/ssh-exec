$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require 'bundler'
require 'rspec/core/rake_task'
require 'rake/clean'

CLEAN.include("**/*.gem")

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :build do
  system "gem build #{GEM_NAME}.gemspec"
end

task :release => :build do
  system "gem push #{GEM_NAME}-#{SshExec::VERSION}"
end
