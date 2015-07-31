ActiveRecord::Schema.define(:version => 0) do
  create_table :users do |t|
    t.string :name
  end

  create_table :posts do |t|
    t.string :text
  end

  create_table :acls do |t|
    t.string :name, unique: true, null: false
  end

  create_table :roles do |t|
    t.string :name, null: false
    t.references :acl, null: false
    t.timestamps
  end
  # Only one duplicate-name role per acl
  add_index :roles, [:name, :acl_id], unique: true

  create_table :user_roles do |t|
    t.references :user
    t.references :role, null: false
    t.references :resource, polymorphic: true

    t.timestamps
  end
  add_index :user_roles, [:resource_type, :resource_id]
  # Only can't be admin of a resource multiple times
  add_index :user_roles, [:user_id, :role_id, :resource_type, :resource_id],
            unique: true, name: :user_roles_avoid_duplicate_roles

  create_table :acl_ownerships do |t|
    t.references :acl, null: false
    t.references :resource, polymorphic: true
  end
  # There can be only one-to-many relationship with a resource
  add_index :acl_ownerships, [:resource_type, :resource_id], unique: true

  create_table :permissions do |t|
    t.string :name, null: false
    t.references :role
  end

  add_index :permissions, [:name, :role_id], unique: true
end
