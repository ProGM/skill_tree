module RolePlay
  module Controller
    def self.included(base)
      base.send :extend, ClassMethods
      base.send :include, InstanceMethods
    end

    module InstanceMethods
      def self.included(base)
        base.send :before_filter, :check_allow_filter!
      end

      def can?(action, resource)
        User.can?(current_user, action, resource)
      end

      private

      def check_allow_filter!
        fail ActionController::RoutingError, 'Not Found' unless can_access?
      end

      def can_access?
        acl = current_acl[action_name]
        if acl.respond_to? :call
          acl.call
        else
          acl || current_acl[:all]
        end
      end

      def current_acl
        self.class.current_acl
      end
    end

    module ClassMethods
      def self.extended(base)
        base.send :cattr_accessor, :current_acl
        base.send :class_variable_set, :@@current_acl, {}
      end

      def allow(*args, &block)
        args.each { |key| current_acl[key] = block }
      end
    end
  end
end
