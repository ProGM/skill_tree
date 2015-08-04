require 'spec_helper'

describe SkillTree::Models::Permission do
  it 'validates name presence' do
    expect(subject).to have(1).error_on(:name)
    subject.name = 'my_name'
    expect(subject).to have(0).error_on(:name)
  end

  it 'validates name uniqueness' do
    subject.name = 'my_name'
    expect(subject).to have(0).error_on(:name)
    SkillTree::Models::Permission.create!(name: 'my_name')
    expect(subject).to have(1).error_on(:name)
  end
end
