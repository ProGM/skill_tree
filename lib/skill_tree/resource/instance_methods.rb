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
        new_acl = parse_acl(value)
        ActiveRecord::Base.transaction do
          acl_ownerships.destroy_all
          acl_ownerships.create!(acl: new_acl)
        end if new_acl != acl
      end

      def permissions_for(user)
        role = SkillTree::Models::Role.find_for(user, self)
        SkillTree::Models::Permission.joins(
          acl_mappings: [:role, :acl])
          .where('("roles"."id" = ?)', role)
          .where('("acls"."id" = ?)', acl)
      end

      def default_permission?(action, role = :user)
        acls.joins(acl_mappings: [:permission, :role])
          .where('"permissions"."name" = ?', action.to_s)
          .where('"roles"."name" = ?', role.to_s).any?
      end

      alias_method :has_default_permission?, :default_permission?

      private

      def parse_acl(value)
        if value.is_a? ActiveRecord::Base
          value
        else
          SkillTree::Models::Acl.find_by!(name: value.to_s)
        end
      end
    end
  end
end
