require 'spec_helper'

describe RolePlay::Resource do
  before(:each) do
    stub_const('Rails', double(root: double))
    allow(Rails.root).to receive(:join)
      .and_return('spec/support/acls/subject_acl.rb')

    RolePlay::Parser.parse!
  end

  let(:current_acl) { RolePlay::Models::Acl.find_by(name: 'posts') }
  let(:user) { User.create! }

  subject { Post.create! }

  it 'has a default acl' do
    expect(subject.acl).not_to be_nil
    expect(subject.acls.first).to eq(subject.acl)
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
