require 'spec_helper'

describe RolePlay::Parser do
  before(:each) do
    stub_const('Rails', double(root: double))
    allow(Rails.root).to receive(:join) { |param| param }
  end

  describe '#parse!' do
    it 'calls setup' do
      expect_any_instance_of(RolePlay::Parser).to receive(:setup)
      described_class.parse!
    end
  end

  describe '#setup' do
    let(:roles) { %w(guest user editor admin) }
    let(:more_roles) { %w(guest user editor admin master) }
    let(:cards) { %w(read create write update delete) }

    it 'parses the acl file updating the model' do
      subject.setup 'spec/support/acls/acl_example.rb'
      acl = RolePlay::Models::Acl.find_by(name: 'desks')
      expect(acl.roles.count).to eq(4)
      acl.roles.each do |role|
        expect(roles).to include(role.name)
        expect(cards).to include(*role.permissions.map(&:name))
      end
    end

    it 'parses files additively' do
      subject.setup 'spec/support/acls/acl_example.rb'
      subject.setup 'spec/support/acls/acl_example2.rb'
      acl = RolePlay::Models::Acl.find_by(name: 'desks')
      expect(acl.roles.count).to eq(5)
      acl.roles.each do |role|
        expect(more_roles).to include(role.name)
        expect(cards).to include(*role.permissions.map(&:name))
      end
      expect(
        acl.roles.find_by(name: 'admin').permissions.where(name: 'update')
      ).to be_any
      expect(
        acl.roles.find_by(name: 'admin').permissions.where(name: 'delete')
      ).not_to be_any
      expect(
        acl.roles.find_by(name: 'master').permissions.where(name: 'delete')
      ).to be_any
    end
  end
end
