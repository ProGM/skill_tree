acl :posts, default_for: :posts do |a|
  a.role :guest do |r|
    r.can :read
  end

  a.role :user do |r|
    r.can :create, :read
  end

  a.role :editor do |r|
    r.inherit :user
    r.can :write
  end

  a.role :admin do |r|
    r.inherit :editor
    r.can :update, :destroy
  end
end

acl :private_post do |a|
  a.role :guest do
  end

  a.role :user do |r|
    r.can :create
  end

  a.role :editor do |r|
    r.inherit :user
    r.can :read, :write, :update
  end

  a.role :admin do |r|
    r.inherit :editor
    r.can :destroy
  end
end
