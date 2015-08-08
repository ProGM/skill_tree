# Default Subject and Resource
Object.send(:remove_const, :User) if defined?(User) # we do this to undefine the model and start fresh, without any of the authorization stuff applied by tests
class User < ActiveRecord::Base
  as_skill_tree_subject
end

Object.send(:remove_const, :Post) if defined?(Post)
class Post < ActiveRecord::Base
  as_skill_tree_resource
end

Object.send(:remove_const, :PostWithAuthor) if defined?(PostWithAuthor)
class PostWithAuthor < ActiveRecord::Base
  belongs_to :user
  as_skill_tree_resource admin: :user
end
