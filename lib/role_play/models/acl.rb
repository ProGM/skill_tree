module RolePlay
  module Models
    class Acl < ActiveRecord::Base
      has_many :acl_ownerships
      has_many :roles

      validates :name, presence: true, uniqueness: true
    end
  end
end