# Default Subject, Role, Permission and Context models
Object.send(:remove_const, :User) if defined?(User) # we do this to undefine the model and start fresh, without any of the authorization stuff applied by tests
class User < ActiveRecord::Base
  include RolePlay::Subject
end

Object.send(:remove_const, :Role) if defined?(Role)
class Post < ActiveRecord::Base
  include RolePlay::Resource
end
