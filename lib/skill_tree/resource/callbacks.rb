module SkillTree
  module Resource
    module Callbacks
      def self.included(base)
        base.before_save do |model|
          unless model.acl
            acl = SkillTree::Parser::Initializer.default_acl_for(model)
            model.acl = acl if acl
          end
        end
        base.after_save :skill_tree_setup_resource_owner
      end

      def skill_tree_setup_resource_owner
        admin = skill_tree_options[:admin]
        send(admin).role!(:admin, self) if admin && acl && try(admin)
      end
    end
  end
end
