$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'role_play/version'

Gem::Specification.new do |s|
  s.name        = 'role_play'
  s.version     = RolePlay::VERSION
  s.summary     = 'Resource-based ACL system for Rails.'
  s.description = 'Resource-based ACL system for Rails.'
  s.authors     = ['Piero Dotti']
  s.email       = ['piero@foldesk.com']
  s.files       = Dir['lib/**/*']
  s.test_files  = Dir['spec/**/*']
  s.homepage    = 'http://github.com/ProGM/role_play'
  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'activesupport', ['~> 4', '< 5']
  s.add_dependency 'activerecord', ['~> 4', '< 5']
  s.add_dependency 'actionpack', ['~> 4', '< 5']
  s.add_dependency 'squeel', '~> 1.2'

  # s.add_development_dependency "rake"
  # s.add_development_dependency "railties"
  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rspec-collection_matchers'
end
