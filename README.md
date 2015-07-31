[![Build Status](https://travis-ci.org/ProGM/role_play.svg)](https://travis-ci.org/ProGM/role_play)
[![Code Climate](https://codeclimate.com/github/ProGM/role_play/badges/gpa.svg)](https://codeclimate.com/github/ProGM/role_play)
[![Test Coverage](https://codeclimate.com/github/ProGM/role_play/badges/coverage.svg)](https://codeclimate.com/github/ProGM/role_play/coverage)

# Role Play
A resource-based ACL system for Rails.

## Getting started

RolePlay is tested on Rails 4.1+, but should run also on previous versions.
You can add it to your Gemfile with:

```ruby
gem 'role_play'
```

Run the bundle command to install it.

After you install RolePlay and add it to your Gemfile, you need to run the generator:

```console
rails generate role_play:install
```

And finally run:

```console
rake db:migrate
```

To run new migrations.

## Configuration
RolePlay requires at least two models, a **Subject** and a **Resource**.
The **Subject** is who could have a role, a **Resource** is who has an acl.

For example we could have a **User** and a **Post**

Let's setup them:

```ruby
class User < ActiveRecord::Base
  include RolePlay::Subject
  ...
end

class Post < ActiveRecord::Base
  include RolePlay::Resource
  ...
end
```

Now, let's define an acl and a list of role for a post.

Open `config/acl.rb`:

```ruby
acl :posts_acl, default_for: :posts do |a|
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
    r.can :update, :delete
  end
end
```

Let's take a look:
`:guest` role is a special one: it's the default role for users with no-user (example: users not logged in).
`:user` is the default logged-user role
Then we have an `:editor` and an `:admin`.

`default_for` means that all posts will have this acl set as default one. You can have multiple acl for a single resource type, for example a **private** post could have an acl like this:


```ruby
acl :private_post do |a|
  a.role :guest do |r|
  end

  a.role :user do |r|
    r.can :create, :read
  end

  a.role :editor do |r|
    r.inherit :user
    r.can :read, :write
  end

  a.role :admin do |r|
    r.inherit :editor
    r.can :update, :delete
  end
end
```

And you can change it:

```ruby
post = Post.first
post.acl = Acl.find_by_name('private_post')
post.save!
```

## Model methods

Now, let's dig into methods:

```ruby
user = User.first
resource = Post.first
```

Set a role to an user:

```ruby
user.role! :editor, resource
```

Check permissions:

```ruby
user.can? :write, resource # => true
user.can? :update, resource # => false
```

Remove roles:

```ruby
user.unrole! :editor, resource
user.can? :write, resource # => false
user.can? :read, resource # => true (fallback to :user role)
```

Check roles:

```ruby
user.role! :editor, resource
user.role? :editor, resource # => true
user.role? :admin, resource # => false
```

## Controller methods

TODO

## Contribute

TODO
