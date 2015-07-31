module RolePlay
  module Models
    class Role < ActiveRecord::Base
      has_many :permissions
      has_many :user_roles
      belongs_to :acl

      validates :acl, presence: true
      validates :name, presence: true
      validates :name, uniqueness: { scope: [:acl_id] }
    end
  end
end
