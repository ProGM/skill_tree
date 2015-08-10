module MockControllerTestHelpers
  def get(method_name)
    described_class.new.invoke method_name
  end
end

class MockController
  class <<self
    def before_filter(method_name, options = {})
      before_filters[:all] = method_name
    end

    def before_filters
      @@before_filters ||= {}
    end
  end

  attr_reader :name, :action_name

  def invoke(action)
    @action_name = action
    send(before_filters[:all]) if before_filters[:all]
    send(action)
  end

  def before_filters
    self.class.before_filters
  end

  def current_user
  end
end

class ApplicationController < MockController
  include SkillTree::Controller
end

class TestController < ApplicationController
  allow(:all) { true }
  allow(:index, :show) { false }
  allow(:create) { can?(:create, post) }
  allow(:destroy) { can?(:destroy, post) }

  def index
  end

  def show
  end

  def update
  end

  def create
  end

  def destroy
  end

  protected

  def post
    @post ||= Post.first
  end
end

class Test2Controller < ApplicationController
  allow(:all) { current_user }

  def show
  end
end
