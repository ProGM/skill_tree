module SkillTree
  module Resource
    module ClassMethods
      def self.extended(base)
        base.send :cattr_accessor, :skill_tree_options
        base.send :class_variable_set, :@@skill_tree_options, {}
      end
    end
  end
end
