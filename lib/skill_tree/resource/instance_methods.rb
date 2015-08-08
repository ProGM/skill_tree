module SkillTree
  module Resource
    module InstanceMethods
      def acl
        acl_ownerships.first.acl if acl_ownerships.first
      end

      def acl=(value)
        if acl_ownerships.empty?
          acl_ownerships.new(acl: value)
        else
          fail SkillTree::AclAlreadySet,
               "#{self.class.name} already has an acl. Use .acl! instead."
        end
      end

      def acl!(value)
        ActiveRecord::Base.transaction do
          acl_ownerships.destroy_all
          acl_ownerships.create!(acl: value)
        end if value != acl
      end

      def default_permission?(action, role = :user)
        acls.joins(acl_mappings: [:permission, :role])
          .where('"permissions"."name" = ?', action.to_s)
          .where('"roles"."name" = ?', role.to_s).any?
      end

      alias_method :has_default_permission?, :default_permission?
    end
  end
end
