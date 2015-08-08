[![Build Status](https://travis-ci.org/ProGM/skill_tree.svg)](https://travis-ci.org/ProGM/skill_tree)
[![Code Climate](https://codeclimate.com/github/ProGM/skill_tree/badges/gpa.svg)](https://codeclimate.com/github/ProGM/skill_tree)
[![Test Coverage](https://codeclimate.com/github/ProGM/skill_tree/badges/coverage.svg)](https://codeclimate.com/github/ProGM/skill_tree/coverage)

# Role Play
A resource-based ACL system for Rails.

## Getting started

SkillTree is tested on Rails 4.1+, but should run also on previous versions.
You can add it to your Gemfile with:

```ruby
gem 'skill_tree'
```

Run the bundle command to install it.

After you install SkillTree and add it to your Gemfile, you need to run the generator:

```console
rails generate skill_tree:install
```

And finally run:

```console
rake db:migrate
```

To run new migrations.

## Configuration
SkillTree requires at least two models, a **Subject** and a **Resource**.
The **Subject** is who could have a role, a **Resource** is who has an acl.

For example we could have a **User** and a **Post**

Let's setup them:

```ruby
class User < ActiveRecord::Base
  as_skill_tree_subject
  ...
end

class Post < ActiveRecord::Base
  as_skill_tree_resource
  ...
end
```

You can also define a default admin role for that post. Example:

```ruby
class Post < ActiveRecord::Base
  belongs_to :user
  as_skill_tree_resource admin: :user
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

`:user` is the default logged-user role.

Then we have an `:editor` and an `:admin`.

`default_for` means that all posts will have this acl set as default one.

In fact you can have multiple acl for a single resource type. For example a **private** post could have an acl like this:


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

As default behaviour, the acl are updated each time you startup your application.

To avoid this, you can add a version number to your acl, so it'll be updated only where the version number changes.

```ruby
acl :post, version: 1 do |a|
  ...
end

acl :post2, version: 3 do |a|
  ...
end
```

## Model methods

Now, let's dig into methods:

```ruby
user = User.first
resource = Post.first
```

### Set a role to an user:

```ruby
user.role! :editor, resource
```

### Check permissions:

```ruby
user.can? :write, resource # => true
user.can? :update, resource # => false
```

### Remove roles:

```ruby
user.unrole! :editor, resource
user.can? :write, resource # => false
user.can? :read, resource # => true (fallback to :user role)
```

### Check roles:

```ruby
user.role! :editor, resource
user.role? :editor, resource # => true
user.role? :admin, resource # => false
```

### List all posts given a permission

```ruby
Post.where_user_can(user, :read)
```

## Controller methods

First of all, let's include SkillTree in ApplicationController

```ruby
  include SkillTree::Controller
```

As a default behaviour, SkillTree negates access to **any** action of **any** controller (security by default).

You can use the `allow` method to decide which action allow to be accessed.

Here's an example:

```ruby
class MyController < ApplicationController
  allow(:index, :show) { true } # Everyone can access to index and key
  allow(:create) { current_user } # Only logged user can create
  allow(:update) { can?(:update, resource) } # Only logged user can create
  allow(:destroy) { can?(:destroy, resource) } # Only logged user can create

  def index; end
  def show; end
  def create; end
  def update; end
  def destroy; end

  private

  def resource
    @resource ||= Post.find(params[:id])
  end
end
```

##Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

##License
See [LICENSE](https://github.com/ProGM/skill_tree/blob/master/LICENSE)
