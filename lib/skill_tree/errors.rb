module SkillTree
  class Error < ::StandardError; end
  class AclAlreadySet < Error; end
  class NotAuthorizedError < Error; end
end
