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
end
