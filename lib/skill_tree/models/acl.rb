module SkillTree
  module Models
    class Acl < ActiveRecord::Base
      has_many :acl_ownerships
      has_many :acl_mappings

      has_many :roles, -> { uniq }, through: :acl_mappings

      validates :name, presence: true, uniqueness: true
    end
  end
end
