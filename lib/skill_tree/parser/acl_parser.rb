module SkillTree
  module Parser
    class AclParser
      attr_reader :roles, :default_for
      def initialize(name, options = {})
        @name = name.to_s
        @default_for = options[:default_for]
        @roles = []
      end

      def role(*args)
        parser = RoleParser.new(*args)
        parser.parent = self
        yield parser
        @roles << parser
      end

      def sync_model
        acl = SkillTree::Models::Acl.find_or_initialize_by(name: @name)
        @roles.each { |role| role.sync_model acl }
        acl.save!
      end

      def model
        SkillTree::Models::Acl.find_by(name: @name)
      end
    end
  end
end