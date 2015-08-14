module SkillTree
  module Subject
    module Initializer
      def as_skill_tree_subject
        send :include, SkillTree::Subject::InstanceMethods
      end
    end
    module InstanceMethods
      def self.included(base)
        base.send :has_many, :user_roles,
                  class_name: 'SkillTree::Models::UserRole'
        base.send :has_many, :roles,
                  through: :user_roles, class_name: 'SkillTree::Models::Role'
      end

      def can?(action, resource)
        resource.default_permission?(action) ||
          permitted_with_role?(action, resource)
      end
      alias_method :allowed_to?, :can?

      def role?(role_name, resource)
        user_roles.joins(:role)
          .where(roles: { name: role_name.to_s })
          .where(resource: resource).any?
      end

      def role!(role, resource)
        role = SkillTree::Models::Role.find_by_name!(role)
        user_role = user_roles.find_or_initialize_by(resource: resource)
        user_role.update!(role: role)
      end

      def unrole!(role, resource)
        role = SkillTree::Models::Role.find_by_name!(role)
        active_roles = user_roles.where(role: role, resource: resource)
        active_roles.destroy_all
      end

      alias_method :has_role?, :role?

      private

      def permitted_with_role?(action, resource)
        user_roles.joins(role: { acl_mappings: [:permission, :acl] })
          .where('"permissions"."name" = ?', action.to_s)
          .where('"acls"."id" = ?', resource.acl)
          .where(resource: resource).any?
      end
    end
  end
end
ActiveRecord::Base.send :extend, SkillTree::Subject::Initializer
