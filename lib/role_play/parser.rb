module RolePlay
  class Parser
    class <<self
      def parse!
        @parser = Parser.new
        @parser.setup if RolePlay::Models::Acl.table_exists?
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
        acl = RolePlay::Models::Acl.find_or_initialize_by(name: @name)
        @roles.each { |role| role.sync_model acl }
        acl.save!
      end

      def model
        RolePlay::Models::Acl.find_by(name: @name)
      end
    end

    class RoleParser
      attr_reader :permissions, :name
      attr_writer :parent
      def initialize(name)
        @name = name.to_s
        @permissions = []
      end

      def can(*args)
        @permissions += args
      end

      def inherit(name)
        element = @parent.roles.select { |e| e.name == name.to_s }.first
        fail "There is no #{name} role" if element.nil?
        @permissions += element.permissions
      end

      def sync_model(acl)
        role = RolePlay::Models::Role.find_or_initialize_by(name: @name)
        role.save!
        sync_permissions(acl, role)
      end

      private

      def sync_permissions(acl, role)
        permission_models = create_permissions!
        permission_models.each do |permission|
          RolePlay::Models::AclMapping.find_or_initialize_by(
            role: role,
            acl: acl,
            permission: permission
          ).save!
        end
        purge_old! acl, role, permission_models
      end

      def create_permissions!
        @permissions.map do |name|
          model = RolePlay::Models::Permission.find_or_initialize_by(name: name)
          model.save!
          model
        end
      end

      def purge_old!(acl, role, permissions)
        RolePlay::Models::AclMapping.where(
          role: role,
          acl: acl
        ).where.not(permission: permissions).destroy_all
      end
    end
  end
end
