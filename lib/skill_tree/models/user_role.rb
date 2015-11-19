module SkillTree
  module Models
    class UserRole < ActiveRecord::Base
      belongs_to :user
      belongs_to :role
      belongs_to :resource, polymorphic: true

      validates :role, presence: true
      validates :user_id, uniqueness: {
        scope: [:resource_id, :resource_type, :role_id],
        message: 'Duplicate role.'
      }
    end
  end
end
