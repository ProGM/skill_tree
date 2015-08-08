require 'skill_tree/resource/callbacks.rb'
require 'skill_tree/resource/class_methods.rb'
require 'skill_tree/resource/instance_methods.rb'
require 'skill_tree/resource/relations.rb'
require 'skill_tree/resource/scopes.rb'

module SkillTree
  module Resource
    module Initializer
      def as_skill_tree_resource(options = {})
        send :include, SkillTree::Resource::InstanceMethods
        send :include, SkillTree::Resource::Relations
        send :include, SkillTree::Resource::Scopes
        send :include, SkillTree::Resource::Callbacks
        send :extend, SkillTree::Resource::ClassMethods
        send :skill_tree_options=, options
      end
    end
  end
end
ActiveRecord::Base.send :extend, SkillTree::Resource::Initializer
