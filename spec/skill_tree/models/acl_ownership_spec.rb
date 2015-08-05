require 'spec_helper'

describe SkillTree::Models::AclOwnership, type: :model do
  it 'belongs to an acl' do
    expect(subject).to be_respond_to(:acl)
  end

  it 'validates presence of acl' do
    expect(subject).to have(1).error_on(:acl)
    subject.acl = build(:acl)
    expect(subject).to have(0).error_on(:acl)
  end

  it 'belongs to a resource' do
    expect(subject).to be_respond_to(:resource)
  end

  it 'resource is polymorphic' do
    subject.resource = User.new
    subject.resource = Post.new
  end

  it 'resource is unique' do
    resource = Post.create!
    acl = create(:acl, name: 'some_name', version: 0)
    described_class.create!(resource: resource, acl: acl)
    subject.resource = User.new
    subject.resource = Post.new
  end
end
