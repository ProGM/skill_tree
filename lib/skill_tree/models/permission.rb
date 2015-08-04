module SkillTree
  module Models
    class Permission < ActiveRecord::Base
      validates :name, presence: true, uniqueness: true
    end
  end
end
