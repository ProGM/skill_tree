require 'spec_helper'

describe SkillTree do
  it '#init! calls Parser' do
    expect(SkillTree::Parser::Initializer).to receive(:parse!)
    described_class.init!
  end
end
