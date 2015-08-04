require 'rails/generators'
require 'rails/generators/migration'

module RolePlay
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    def self.next_migration_number(_path)
      Time.now.utc.strftime('%Y%m%d%H%M%S')
    end

    def create_model_file
      copy_file 'initializer.rb', 'config/initializers/role_play.rb'
      copy_file 'acl.rb', 'config/acl.rb'
      migration_template 'create_role_play_acl_system.rb',
                         'db/migrate/create_role_play_acl_system.rb'
    end
  end
end
