#
# Example acl.rb file
#

# acl :posts_acl, default_for: :posts do |a|
#   a.role :guest do |r|
#     r.can :read
#   end

#   a.role :user do |r|
#     r.can :create, :read
#   end

#   a.role :editor do |r|
#     r.inherit :user
#     r.can :write
#   end

#   a.role :admin do |r|
#     r.inherit :editor
#     r.can :update, :delete
#   end
# end

# acl :private_post do |a|
#   a.role :guest do |r|
#   end

#   a.role :user do |r|
#     r.can :create, :read
#   end

#   a.role :editor do |r|
#     r.inherit :user
#     r.can :read, :write
#   end

#   a.role :admin do |r|
#     r.inherit :editor
#     r.can :update, :delete
#   end
# end
