module SkillTree
  module Models
    class Role < ActiveRecord::Base
      has_many :user_roles
      has_many :acl_mappings
      validates :name, presence: true, uniqueness: true

      def self.find_for(user, resource)
        if user
          user_role = user.user_roles.where(resource: resource).first
          if user_role
            user_role.role
          else
            find_by_name!('user')
          end
        else
          find_by_name!('guest')
        end
      end
    end
  end
end
