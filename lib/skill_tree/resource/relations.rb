module SkillTree
  module Resource
    module Relations
      def self.included(base)
        base.has_many :acl_ownerships,
                      as: :resource,
                      class_name: 'SkillTree::Models::AclOwnership'
        base.has_many :acls,
                      through: :acl_ownerships,
                      class_name: 'SkillTree::Models::Acl'
        base.has_many :roles, through: :acls,
                              class_name: 'SkillTree::Models::Role'
        base.has_many :user_roles,
                      as: :resource, class_name: 'SkillTree::Models::UserRole'
      end
    end
  end
end
