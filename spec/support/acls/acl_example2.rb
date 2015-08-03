acl :desks do |a|
  a.role :guest do |r|
    r.can :read
  end

  a.role :user do |r|
    r.can :create, :read, :write
  end

  a.role :editor do |r|
    r.inherit :user
    r.can :write, :write, :write
  end

  a.role :admin do |r|
    r.inherit :editor
    r.can :update
  end

  a.role :master do |r|
    r.inherit :admin
    r.can :destroy
  end
end
