module SkillTree
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
        if current_user
          current_user.can?(action, resource)
        else
          resource.default_permission?(action, :guest)
        end
      end

      private

      def check_allow_filter!
        fail SkillTree::NotAuthorizedError unless can_access?
      end

      def can_access?
        acl = current_acl[action_name.to_sym]
        if acl.respond_to? :call
          instance_eval(&acl)
        elsif default_acl.respond_to? :call
          instance_eval(&default_acl)
        end
      end

      private

      def default_acl
        current_acl[:all]
      end

      def current_acl
        self.class.current_acl
      end
    end

    module ClassMethods
      def current_acl
        @current_acl ||= {}
      end

      def allow(*args, &block)
        args.each { |key| current_acl[key] = block }
      end
    end
  end
end
