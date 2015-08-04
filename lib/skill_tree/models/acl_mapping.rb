module SkillTree
  module Models
    class AclMapping < ActiveRecord::Base
      belongs_to :acl
      belongs_to :role
      belongs_to :permission

      validates :acl, presence: true
      validates :role, presence: true
      validates :permission, presence: true
      validates :acl_id, uniqueness: {
        scope: [:permission_id, :role_id]
      }
    end
  end
end
