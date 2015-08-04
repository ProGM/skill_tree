require 'spec_helper'

describe SkillTree::Models::Acl do
  it 'validates name presence' do
    expect(subject).to have(1).error_on(:name)
    subject.name = 'my_name'
    expect(subject).to have(0).error_on(:name)
  end

  it 'validates name uniqueness' do
    described_class.create!(name: 'my_name')
    subject.name = 'my_name'
    expect(subject).to have(1).error_on(:name)
  end

  it 'has many roles' do
    expect(subject).to be_respond_to(:roles)
    expect(subject.roles.model.name).to eq('SkillTree::Models::Role')
  end

  it 'has many acl_mappings' do
    expect(subject).to be_respond_to(:acl_mappings)
    expect(subject.acl_mappings.model.name).to eq(
      'SkillTree::Models::AclMapping')
  end

  it 'has many acl_ownerships' do
    expect(subject).to be_respond_to(:acl_ownerships)
    expect(subject.acl_ownerships.model.name).to eq(
      'SkillTree::Models::AclOwnership')
  end
end
