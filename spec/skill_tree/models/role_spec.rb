require 'spec_helper'

describe SkillTree::Models::Role, type: :model do
  it 'validates name presence' do
    expect(subject).to have(1).error_on(:name)
    subject.name = 'my_name'
    expect(subject).to have(0).error_on(:name)
  end

  it 'validates name uniqueness' do
    create(:role, name: 'my_name')
    subject.name = 'my_name'
    expect(subject).to have(1).error_on(:name)
  end

  describe '#find_for' do
    before(:each) do
      stub_const('Rails', double(root: double))
      allow(Rails.root).to receive(:join)
        .and_return('spec/support/acls/subject_acl.rb')

      SkillTree::Parser::Initializer.parse!
    end
    let(:user) { User.create! }
    let(:resource) { Post.create! }
    it 'finds the current role of an user given a resource' do
      expect(role_for(nil, resource)).to eq('guest')
      expect(role_for(user, resource)).to eq('user')
      user.role! :editor, resource
      expect(role_for(user, resource)).to eq('editor')
      user.role! :admin, resource
      expect(role_for(user, resource)).to eq('admin')
      user.unrole! :admin, resource
      expect(role_for(user, resource)).to eq('user')
    end

    def role_for(user, resource)
      described_class.find_for(user, resource).name
    end
  end
end
