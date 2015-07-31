module RolePlay
  module Models
    class AclOwnership < ActiveRecord::Base
      belongs_to :acl
      belongs_to :resource, polymorphic: true

      validates :acl, presence: true
      validates :resource_id, uniqueness: { scope: [:resource_type] }
    end
  end
end
