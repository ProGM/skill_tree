ActiveRecord::Schema.define(version: 0) do
  create_table :users do |t|
    t.string :name
  end

  create_table :posts do |t|
    t.string :text
  end

  create_table :acls do |t|
    t.string :name, null: false
    t.integer :version, null: false
  end
  add_index :acls, :name, unique: true

  create_table :roles do |t|
    t.string :name, null: false
  end
  add_index :roles, :name, unique: true

  create_table :permissions do |t|
    t.string :name, null: false
  end
  add_index :permissions, :name, unique: true

  create_table :acl_mappings do |t|
    t.references :acl, null: false
    t.references :role, null: false
    t.references :permission, null: true

    t.timestamps null: false
  end

  add_index :acl_mappings, [:acl_id, :role_id, :permission_id], unique: true

  create_table :user_roles do |t|
    t.references :user
    t.references :role, null: false
    t.references :resource, polymorphic: true

    t.timestamps null: false
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
end
