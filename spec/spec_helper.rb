require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
require 'active_support'
require 'active_record'
require 'action_controller'
require 'skill_tree'
require 'generators/skill_tree/install_generator'
require 'rspec'
require 'rspec/collection_matchers'
require 'generator_spec'

I18n.enforce_available_locales = false

Dir[File.join(File.dirname(__FILE__), '..', 'spec/support/*.rb')].each { |f| require f }

RSpec::Expectations.configuration.warn_about_potential_false_positives = false

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
    capture_stdout { load 'db/schema.rb' }
  end

  config.before(:each) do
    load 'support/models.rb'
  end

  config.include MockControllerTestHelpers, type: :controller
  config.include ModelBuilder, type: :model

  config.around(:each) do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
