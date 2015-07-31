require 'spec_helper'

describe RolePlay::Models::UserRole do
  it 'users can\'t have duplicate roles for the same resource' do
    user = User.create!
    resource = Post.create!

    acl = RolePlay::Models::Acl.create!(name: 'aaa')

    role = RolePlay::Models::Role.create!(name: 'name', acl: acl)

    described_class.create!(role: role, user: user, resource: resource)

    subject.assign_attributes(role: role, user: user, resource: resource)
    expect(subject).to have(1).error_on(:user_id)
    subject.user = nil
    expect(subject).to have(0).error_on(:user_id)
  end
end
