require 'spec_helper'

describe RolePlay::Models::Permission do
  it 'validates name presence' do
    expect(subject).to have(1).error_on(:name)
    subject.name = 'my_name'
    expect(subject).to have(0).error_on(:name)
  end

  it 'validates name uniqueness given a role' do
    acl = RolePlay::Models::Acl.create!(name: 'test')
    role = RolePlay::Models::Role.create!(name: 'test', acl: acl)
    role2 = RolePlay::Models::Role.create!(name: 'test2', acl: acl)
    described_class.create!(name: 'my_name', role: role)
    subject.name = 'my_name'
    subject.role = role
    expect(subject).to have(1).error_on(:name)
    subject.role = role2
    expect(subject).to have(0).error_on(:name)
  end

  it 'belongs to a role' do
    expect(subject).to be_respond_to(:role)
    subject.role = RolePlay::Models::Role.new
  end
end
