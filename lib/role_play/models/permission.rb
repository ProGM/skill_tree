module RolePlay
  module Models
    class Permission < ActiveRecord::Base
      belongs_to :role

      validates :role, presence: true
      validates :name, presence: true
      validates :name, uniqueness: { scope: [:role_id] }
    end
  end
end
