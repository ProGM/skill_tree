require 'spec_helper'

describe RolePlay::Models::AclMapping do
  it 'belongs to an acl' do
    expect(subject).to respond_to(:acl)
  end

  it 'validates presence of acl' do
    expect(subject).to have(1).error_on(:acl)
    subject.acl = RolePlay::Models::Acl.new
    expect(subject).to have(0).error_on(:acl)
  end

  it 'belongs to a role' do
    expect(subject).to respond_to(:role)
  end

  it 'validates presence of role' do
    expect(subject).to have(1).error_on(:role)
    subject.role = RolePlay::Models::Role.new
    expect(subject).to have(0).error_on(:role)
  end

  it 'belongs to a permission' do
    expect(subject).to respond_to(:permission)
  end

  it 'validates presence of permission' do
    expect(subject).to have(1).error_on(:permission)
    subject.permission = RolePlay::Models::Permission.new
    expect(subject).to have(0).error_on(:permission)
  end

  it 'validates uniqueness of relations' do
    acl_mapping = RolePlay::Models::AclMapping.create!(
      role: RolePlay::Models::Role.create!(name: 'a'),
      acl: RolePlay::Models::Acl.create!(name: 'b'),
      permission: RolePlay::Models::Permission.create!(name: 'c')
    )
    subject.assign_attributes(
      role: acl_mapping.role,
      acl: acl_mapping.acl,
      permission: acl_mapping.permission
    )
    expect(subject).to have(1).error_on(:acl_id)
  end
end
