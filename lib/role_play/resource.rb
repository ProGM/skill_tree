module RolePlay
  module Resource
    extend ActiveSupport::Concern

    included do
      has_many :acl_ownerships,
               as: :resource, class_name: 'RolePlay::Models::AclOwnership'
      has_many :acls,
               through: :acl_ownerships, class_name: 'RolePlay::Models::Acl'
      has_many :roles, through: :acls, class_name: 'RolePlay::Models::Role'
      has_many :user_roles, class_name: 'RolePlay::Models::UserRole'
      scope :where_user_can, lambda { |user, action|
        if user
          user_id = user.id
          joins(acls: { roles: :permissions })
          .joins("LEFT OUTER JOIN \"user_roles\" ON \"user_roles\".\"resource_id\" = \"#{table_name}\".\"id\" AND \"user_roles\".\"resource_type\" = '#{name}'")
            .where(permissions: { name: action.to_s })
            .where('"user_roles"."id" IS NULL OR "user_roles"."role_id" = "roles"."id"')
            .where('("user_roles"."user_id" IS NULL AND "roles"."name" = ?) OR ("user_roles"."user_id" = ?)', 'user', user_id)
            .uniq
        else
          joins(acls: { roles: :permissions })
            .where(permissions: { name: action.to_s })
            .where(roles: { name: 'guest' })
            .uniq
        end
      }

      before_save do |model|
        model.acl = RolePlay::Parser.default_acl_for(model) unless model.acl
      end
    end

    def acl
      acl_ownerships.first.acl if acl_ownerships.first
    end

    def acl=(value)
      if acl_ownerships.empty?
        acl_ownerships.new(acl: value)
      else
        acl_ownerships.first.acl = value
      end
    end

    def default_permission?(action, role = :user)
      acls.joins(roles: :permissions)
        .where(permissions: { name: action })
        .where(roles: { name: role }).any?
    end
  end
end
