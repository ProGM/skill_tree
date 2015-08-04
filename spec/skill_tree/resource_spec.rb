require 'spec_helper'

describe SkillTree::Resource do
  before(:each) do
    stub_const('Rails', double(root: double))
    allow(Rails.root).to receive(:join)
      .and_return('spec/support/acls/subject_acl.rb')

    SkillTree::Parser::Initializer.parse!
  end

  let(:private_acl) { SkillTree::Models::Acl.find_by(name: 'private_post') }
  let(:user) { User.create! }

  subject { Post.create! }

  it 'has a default acl' do
    expect(subject.acl).not_to be_nil
    expect(subject.acls.first).to eq(subject.acl)
  end

  it 'can\'t assign a new acl' do
    expect do
      subject.update(acl: private_acl)
    end.to raise_error SkillTree::AclAlreadySet
  end

  it '#default_permission?' do
    expect(subject).to have_default_permission(:read)
    expect(subject).to have_default_permission(:create)
    expect(subject).not_to have_default_permission(:write)
    expect(subject).to have_default_permission(:read, :guest)
    expect(subject).not_to have_default_permission(:create, :guest)
  end

  it 'can change his acl, resetting all roles' do
    user.role! :editor, subject
    expect(user).to be_allowed_to :write, subject
    expect(user).not_to be_allowed_to :update, subject
    subject.acl! private_acl
    expect(user).to have_role :editor, subject
    expect(user).to be_allowed_to :update, subject
    expect(user).not_to be_allowed_to :destroy, subject
  end

  describe '#where_user_can' do
    it 'selector for guest' do
      expect(Post.where_user_can(nil, :read)).to include(subject)
      expect(Post.where_user_can(nil, :create)).not_to include(subject)
      expect(Post.where_user_can(nil, :write)).not_to include(subject)
      expect(Post.where_user_can(nil, :destroy)).not_to include(subject)
    end

    it 'selector for logged user' do
      expect(Post.where_user_can(user, :read)).to include(subject)
      expect(Post.where_user_can(user, :create)).to include(subject)
      expect(Post.where_user_can(user, :write)).not_to include(subject)
      expect(Post.where_user_can(user, :destroy)).not_to include(subject)
    end

    it 'selector for editor' do
      user.role!(:editor, subject)
      expect(Post.where_user_can(user, :read)).to include(subject)
      expect(Post.where_user_can(user, :create)).to include(subject)
      expect(Post.where_user_can(user, :write)).to include(subject)
      expect(Post.where_user_can(user, :destroy)).not_to include(subject)
    end

    it 'selector for admin' do
      user.role!(:admin, subject)
      expect(Post.where_user_can(user, :read)).to include(subject)
      expect(Post.where_user_can(user, :create)).to include(subject)
      expect(Post.where_user_can(user, :write)).to include(subject)
      expect(Post.where_user_can(user, :destroy)).to include(subject)
      expect(Post.where_user_can(user, :foo)).not_to include(subject)
    end
  end
end