require 'skill_tree/parser/acl_parser.rb'
require 'skill_tree/parser/role_parser.rb'

module SkillTree
  module Parser
    class Initializer
      class <<self
        def parse!
          @parser = Initializer.new
          @parser.setup if SkillTree::Models::Acl.table_exists?
        end

        def default_acl_for(model)
          @parser.acls.each do |acl|
            return acl.model if acl.default_for.to_s == model.class.table_name
          end if @parser
          nil
        end
      end

      attr_reader :acls
      def initialize
        @acls = []
      end

      def setup(filename = 'config/acl.rb')
        instance_eval(File.read(Rails.root.join(filename)))
        save_db!
      end

      def acl(*args)
        acl = AclParser.new(*args)
        yield acl
        @acls << acl
      end

      private

      def save_db!
        @acls.map(&:sync_model)
      end
    end
  end
end
