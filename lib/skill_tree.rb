require 'skill_tree/controller.rb'
require 'skill_tree/errors.rb'
require 'skill_tree/models.rb'
require 'skill_tree/parser.rb'
require 'skill_tree/resource.rb'
require 'skill_tree/subject.rb'
require 'skill_tree/version.rb'

module SkillTree
  class <<self
    def init!
      SkillTree::Parser::Initializer.parse!
    end
  end
end
