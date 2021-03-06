require 'spec_helper'

describe SkillTree::Parser::Initializer do
  before(:each) do
    stub_const('Rails', double(root: double))
    allow(Rails.root).to receive(:join) { |param| param }
  end

  describe '#parse!' do
    it 'calls setup' do
      expect_any_instance_of(described_class).to receive(:setup)
      described_class.parse!
    end
  end

  describe '#setup' do
    let(:roles) { %w(guest user editor admin) }
    let(:more_roles) { %w(guest user editor admin master) }
    let(:permissions) { %w(read create write update delete) }

    it 'parses the acl file updating the model' do
      subject.setup 'spec/support/acls/acl_example.rb'
      acl = SkillTree::Models::Acl.find_by(name: 'desks')
      expect(acl.roles.count).to eq(4)
      expect(SkillTree::Models::Role.where(name: roles).count).to eq(roles.count)
      expect(acl.roles.count).to eq(4)
      expect(permission(acl, 'guest', 'read')).to be_any
      expect(permission(acl, 'guest', 'write')).not_to be_any
      expect(permission(acl, 'admin', 'destroy')).to be_any
    end

    it 'parses files additively' do
      subject.setup 'spec/support/acls/acl_example.rb'
      subject.setup 'spec/support/acls/acl_example2.rb'
      acl = SkillTree::Models::Acl.find_by(name: 'desks')
      model_roles = SkillTree::Models::Role.where(name: roles)
      expect(model_roles.count).to eq(roles.count)
      expect(acl.roles.count).to eq(5)

      expect(permission(acl, 'admin', 'read')).to be_any
      expect(permission(acl, 'master', 'destroy')).to be_any
      expect(permission(acl, 'admin', 'destroy')).not_to be_any
    end

    describe 'versioning:' do
      before { subject.setup 'spec/support/acls/acl_example3.rb' }
      it 'when the version is identical, changes nothing' do
        expect_any_instance_of(SkillTree::Models::Acl).not_to receive(:save!)
        subject.setup 'spec/support/acls/acl_example3.rb'
      end
      it 'when the version changes, recomputes everything' do
        expect_any_instance_of(SkillTree::Models::Acl).to receive(:save!)
          .and_call_original
        subject.setup 'spec/support/acls/acl_example4.rb'
        expect(SkillTree::Models::Acl.first.version).to eq(2)
      end
    end
  end

  def permission(acl, role, permission)
    acl = SkillTree::Models::Acl.find_by(name: acl) if acl.is_a? String
    role = SkillTree::Models::Role.find_by(name: role) if role.is_a? String
    permission = SkillTree::Models::Permission
                 .find_by(name: permission) if permission.is_a? String
    SkillTree::Models::AclMapping.where(
      role: role,
      acl: acl,
      permission: permission
    )
  end
end
