require 'spec_helper'

describe TestController, type: :controller do
  before(:each) do
    stub_const('Rails', double(root: double))
    allow(Rails.root).to receive(:join)
      .and_return('spec/support/acls/subject_acl.rb')
    SkillTree::Parser::Initializer.parse!
  end

  let(:user) { User.create! }

  let(:admin) do
    user = User.create!
    user.role! :admin, resource
    user
  end

  let!(:resource) { Post.create! }

  it '#index' do
    expect_any_instance_of(TestController).not_to receive(:update)
    expect { get :index }.to raise_error SkillTree::NotAuthorizedError
  end

  it '#show' do
    expect_any_instance_of(TestController).not_to receive(:update)
    expect { get :index }.to raise_error SkillTree::NotAuthorizedError
  end

  it '#update' do
    expect_any_instance_of(TestController).to receive(:update)
    get :update
  end

  describe '#create' do
    it 'is open for a logged user' do
      allow_any_instance_of(TestController).to receive(:current_user)
        .and_return(user)
      expect_any_instance_of(TestController).to receive(:create)
      get :create
    end

    it 'is blocked for a guest' do
      expect_any_instance_of(TestController).not_to receive(:create)
      expect { get :create }.to raise_error SkillTree::NotAuthorizedError
    end
  end

  describe '#destroy' do
    it 'is open for an admin' do
      allow_any_instance_of(TestController).to receive(:current_user)
        .and_return(admin)
      expect_any_instance_of(TestController).to receive(:destroy)
      get :destroy
    end

    it 'is blocked for a logged user' do
      allow_any_instance_of(TestController).to receive(:current_user)
        .and_return(user)
      expect_any_instance_of(TestController).not_to receive(:destroy)
      expect { get :destroy }.to raise_error SkillTree::NotAuthorizedError
    end

    it 'is blocked for a guest' do
      expect_any_instance_of(TestController).not_to receive(:destroy)
      expect { get :destroy }.to raise_error SkillTree::NotAuthorizedError
    end
  end
end

describe Test2Controller, type: :controller do
  before(:each) do
    stub_const('Rails', double(root: double))
    allow(Rails.root).to receive(:join)
      .and_return('spec/support/acls/subject_acl.rb')
    SkillTree::Parser::Initializer.parse!
  end

  let(:user) { User.create! }
  let!(:resource) { Post.create! }

  describe '#index' do
    it 'returns error if the user is not logged in' do
      expect_any_instance_of(Test2Controller).not_to receive(:index)
      expect { get :index }.to raise_error SkillTree::NotAuthorizedError
    end

    it 'works only when user is logged in' do
      allow_any_instance_of(Test2Controller).to receive(:current_user)
        .and_return(user)

      expect_any_instance_of(Test2Controller).to receive(:index)
      get :index
    end
  end

  describe '#current_acl' do
    it 'differs between classes with common parent' do
      expect(TestController.current_acl).not_to eq(Test2Controller.current_acl)
    end
  end
end
