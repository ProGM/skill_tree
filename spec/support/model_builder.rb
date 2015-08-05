module ModelBuilder
  def create(name, attributes = {})
    klass = class_by_symbol(name)
    klass.create!(attributes)
  end

  def build(name, attributes = {})
    klass = class_by_symbol(name)
    klass.new(attributes)
  end

  def class_by_symbol(name)
    "SkillTree::Models::#{name.to_s.classify}".constantize
  end
end
