GEM_NAME = 'ssh-exec'

require File.expand_path("../lib/#{GEM_NAME}/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Mikhail Bautin']
  gem.email         = ['mbautin@gmail.com']
  gem.summary       = 'A library allowing to execute commands over SSH using Net::SSH'
  gem.description   = gem.summary
  gem.homepage      = "http://github.com/mbautin/#{GEM_NAME}"
  gem.licenses      = ['Apache 2.0']

  gem.executables   = `git ls-files -- bin/*`.split('\n').map{ |f| File.basename(f.strip) }
  gem.files         = `git ls-files`.split("\n").map(&:strip)
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split('\n').map(&:strip)
  gem.name          = GEM_NAME
  gem.require_paths = ['lib']
  gem.version       = SshExec::VERSION

  gem.add_dependency 'net-ssh', '~> 3.0'

  gem.add_development_dependency 'rake', '~> 10.1'
  gem.add_development_dependency 'rspec', '~> 2.14'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'

end
