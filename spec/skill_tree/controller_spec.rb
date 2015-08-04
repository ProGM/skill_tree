require 'spec_helper'

describe TestController, type: :controller do
  before(:each) do
    stub_const('Rails', double(root: double))
    allow(Rails.root).to receive(:join)
      .and_return('spec/support/acls/subject_acl.rb')
    SkillTree::Parser.parse!
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
    expect { get :index }.to raise_error ActionController::RoutingError
  end

  it '#show' do
    expect_any_instance_of(TestController).not_to receive(:update)
    expect { get :index }.to raise_error ActionController::RoutingError
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
      expect { get :create }.to raise_error ActionController::RoutingError
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
      expect { get :destroy }.to raise_error ActionController::RoutingError
    end

    it 'is blocked for a guest' do
      expect_any_instance_of(TestController).not_to receive(:destroy)
      expect { get :destroy }.to raise_error ActionController::RoutingError
    end
  end
end
