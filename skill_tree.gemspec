$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'skill_tree/version'

Gem::Specification.new do |s|
  s.name        = 'skill_tree'
  s.version     = SkillTree::VERSION
  s.summary     = 'Resource-based ACL system for Rails.'
  s.description = 'A simple and complete ACL system for Rails, '\
  'that allows to specify an user-based role for a generic resource.'
  s.authors     = ['Piero Dotti']
  s.email       = ['piero@foldesk.com']
  s.files       = Dir['lib/**/*']
  s.test_files  = Dir['spec/**/*']
  s.homepage    = 'http://github.com/ProGM/skill_tree'
  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'activesupport', ['~> 4', '< 5']
  s.add_dependency 'activerecord', ['~> 4', '< 5']
  s.add_dependency 'actionpack', ['~> 4', '< 5']

  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'generator_spec'
  s.add_development_dependency 'rspec-collection_matchers'
end
