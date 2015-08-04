require 'rails/generators'
require 'rails/generators/migration'

module SkillTree
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)

    def self.next_migration_number(_path)
      Time.now.utc.strftime('%Y%m%d%H%M%S')
    end

    def create_model_file
      copy_file 'initializer.rb', 'config/initializers/skill_tree.rb'
      copy_file 'acl.rb', 'config/acl.rb'
      migration_template 'create_skill_tree_acl_system.rb',
                         'db/migrate/create_skill_tree_acl_system.rb'
    end
  end
end
