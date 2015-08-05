module SkillTree
  module Parser
    class AclParser
      attr_reader :roles, :default_for
      def initialize(name, options = {})
        @name = name.to_s
        @default_for = options[:default_for]
        @roles = []
        @version = options[:version]
      end

      def role(*args)
        parser = RoleParser.new(*args)
        parser.parent = self
        yield parser
        @roles << parser
      end

      def sync_model
        acl = SkillTree::Models::Acl.find_or_initialize_by(name: @name)
        return if version_match? acl
        update_version acl
        @roles.each { |role| role.sync_model acl }
        acl.save!
      end

      def model
        SkillTree::Models::Acl.find_by(name: @name)
      end

      private

      def version_match?(acl)
        !acl.new_record? && acl.version == @version
      end

      def update_version(acl)
        acl.version = @version || 0
      end
    end
  end
end
