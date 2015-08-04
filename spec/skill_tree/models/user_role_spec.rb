require 'spec_helper'

describe SkillTree::Models::UserRole do
  it 'users can\'t have duplicate roles for the same resource' do
    user = User.create!
    resource = Post.create!
    role = SkillTree::Models::Role.create!(name: 'name')

    described_class.create!(role: role, user: user, resource: resource)

    subject.assign_attributes(role: role, user: user, resource: resource)
    expect(subject).to have(1).error_on(:user_id)
    subject.user = nil
    expect(subject).to have(0).error_on(:user_id)
  end
end
