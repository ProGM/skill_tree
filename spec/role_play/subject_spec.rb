require 'spec_helper'

describe RolePlay::Subject do
  before(:each) do
    stub_const('Rails', double(root: double))
    allow(Rails.root).to receive(:join).and_return('spec/support/acls/subject_acl.rb')
    RolePlay::Parser.parse!
  end

  let(:current_acl) { RolePlay::Models::Acl.find_by(name: 'posts') }

  let(:resource) do
    Post.create!(acl: current_acl)
  end

  subject { User.create! }

  it '#can?' do
    expect(subject).to be_allowed_to(:read, resource)
    expect(subject).not_to be_allowed_to(:write, resource)
  end

  describe '#role!' do
    it 'sets a only one role per resource' do
      subject.role! :editor, resource
      expect(subject).to have_role(:editor, resource)
      subject.role! :admin, resource
      expect(subject).not_to have_role(:editor, resource)
      expect(subject).to have_role(:admin, resource)
    end

    it 'can\'t set a role that does not exist' do
      expect do
        subject.role! :foo, resource
      end.to raise_error ActiveRecord::RecordNotFound
    end
  end

  it '#role?' do
    expect(subject).not_to have_role(:admin, resource)
    subject.role! :admin, resource
    expect(subject).to have_role(:admin, resource)
  end
end