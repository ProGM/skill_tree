require 'spec_helper'

describe RolePlay::Models::Role do
  it 'validates name presence' do
    expect(subject).to have(1).error_on(:name)
    subject.name = 'my_name'
    expect(subject).to have(0).error_on(:name)
  end

  it 'validates name uniqueness given a name' do
    acl = RolePlay::Models::Acl.create!(name: 'test')
    acl2 = RolePlay::Models::Acl.create!(name: 'test2')
    described_class.create!(name: 'my_name', acl: acl)
    subject.name = 'my_name'
    subject.acl = acl
    expect(subject).to have(1).error_on(:name)
    subject.acl = acl2
    expect(subject).to have(0).error_on(:name)
  end

  it 'belongs to an acl' do
    expect(subject).to be_respond_to(:acl)
    subject.acl = RolePlay::Models::Acl.new
  end
end
