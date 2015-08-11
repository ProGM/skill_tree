module SkillTree
  module Resource
    module Scopes
      extend ActiveSupport::Concern
      included do
        scope :where_user_can, lambda { |user, action|
          if user
            where_logged_user_can(action, user.id)
          else
            where_guest_can(action)
          end
        }

        scope :with_permissions, lambda {
          joins(acls: { acl_mappings: [:permission, :role] })
        }

        scope :where_guest_can, lambda { |action|
          with_permissions
            .where('"permissions"."name" = ?', action.to_s)
            .where('"roles"."name" = ?', 'guest')
        }

        scope :where_logged_user_can, lambda { |action, user_id|
          with_permissions
            .joins("LEFT OUTER JOIN \"user_roles\""\
              " ON \"user_roles\".\"resource_id\" = \"#{table_name}\".\"id\""\
              " AND \"user_roles\".\"resource_type\" = '#{name}'")
            .where('"permissions"."name" = ?', action.to_s)
            .where('("user_roles"."role_id" = "roles"."id"'\
                   ' AND "user_roles"."user_id" = ?) OR ("roles"."name" = ?)',
                   user_id, 'user')
            .uniq
        }
      end
    end
  end
end
