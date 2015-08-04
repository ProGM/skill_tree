module SkillTree
  module Parser
    class RoleParser
      attr_reader :permissions, :name
      attr_writer :parent
      def initialize(name)
        @name = name.to_s
        @permissions = []
      end

      def can(*args)
        @permissions += args
      end

      def inherit(name)
        element = @parent.roles.select { |e| e.name == name.to_s }.first
        fail "There is no #{name} role" if element.nil?
        @permissions += element.permissions
      end

      def sync_model(acl)
        role = SkillTree::Models::Role.find_or_initialize_by(name: @name)
        role.save!
        sync_permissions(acl, role)
      end

      private

      def sync_permissions(acl, role)
        permission_models = create_permissions!
        permission_models.each do |permission|
          SkillTree::Models::AclMapping.find_or_initialize_by(
            role: role,
            acl: acl,
            permission: permission
          ).save!
        end
        purge_old! acl, role, permission_models
      end

      def create_permissions!
        @permissions.map do |name|
          model = SkillTree::Models::Permission.find_or_initialize_by(name: name)
          model.save!
          model
        end
      end

      def purge_old!(acl, role, permissions)
        SkillTree::Models::AclMapping.where(
          role: role,
          acl: acl
        ).where.not(permission: permissions).destroy_all
      end
    end
  end
end
