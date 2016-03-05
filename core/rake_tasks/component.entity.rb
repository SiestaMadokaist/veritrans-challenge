class ComponentGenerator
  class Entity < Base

    def directory
      "#{@generator.directory}/entity"
    end

    def template
      <<-EOF
class Component::#{class_name}::Entity < Grape::Entity
  # expose(:some_symbol)
end
      EOF
    end
  end
end
