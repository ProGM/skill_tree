require 'spec_helper'

describe SkillTree::InstallGenerator, type: :generator do
  destination File.expand_path('../../tmp', __FILE__)
  arguments %w()

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'creates a migration, an acl and an initializer' do
    expect(destination_root).to have_structure {
      no_file 'test.rb'
      directory 'config' do
        directory 'initializers' do
          file 'skill_tree.rb' do
            contains 'SkillTree.init!'
          end
        end
        file 'acl.rb' do
          contains 'Example acl.rb file'
        end
      end
      directory 'db' do
        directory 'migrate' do
          migration 'create_skill_tree_acl_system' do
            contains 'class CreateSkillTreeAclSystem'
          end
        end
      end
    }
  end
end
