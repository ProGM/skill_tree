module SkillTree
  module Generators
    module OrmHelpers
      def migration_exists?
        Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb")
          .grep(/\d+_create_skill_tree_acl_system.rb$/).first
      end

      def migration_path
        @migration_path ||= File.join('db', 'migrate')
      end
    end
  end
end
