module SkillTree
  module Models
    class Permission < ActiveRecord::Base
      has_many :acl_mappings
      validates :name, presence: true, uniqueness: true

      scope :names, -> { pluck(:name).map(&:to_sym) }
    end
  end
end
