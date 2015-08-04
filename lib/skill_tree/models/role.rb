module SkillTree
  module Models
    class Role < ActiveRecord::Base
      has_many :user_roles
      has_many :acl_mappings
      validates :name, presence: true, uniqueness: true
    end
  end
end
