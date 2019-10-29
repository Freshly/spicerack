# frozen_string_literal: true

module Spicerack
  # Finds classes of a specific type related to a given object based on a set of predictable rules.
  #
  #     class FooBar < ApplicationRecord; end
  #     class FooBarMaterial < ApplicationMaterial; end
  #     class FooBarList < ApplicationList; end
  #
  #     material_finder = Spicerack::ClassFinder.new("Material")
  #     list_finder = Spicerack::ClassFinder.new("List")
  #
  # Works when given a related class:
  #
  #     material_finder.class_for(FooBar) # => FooBarMaterial
  #     list_finder.class_for(FooBar) # => FooBarList
  #
  # Or when given an instance of a related class:
  #
  #     material_finder.class_for(FooBar.new) # => FooBarMaterial
  #     list_finder.class_for(FooBar.new) # => FooBarMaterial
  #
  # If no class can be found, it returns nil:
  #
  #     material_finder.class_for(Baz.new) # => nil
  #
  # You can use the `class_for!` variant to raise a NotFoundError error instead:
  #
  #     material_finder.class_for(Baz.new) # => raises NotFoundError, could not find `Material' for `#<Baz ...>'
  #
  # Objects can define an explicit method rather than defer to the implicit lookup:
  #
  #     class Gaz < ApplicationRecord
  #       def self.material_class
  #         FooBarMaterial
  #       end
  #
  #       def material_class
  #         GazMaterial
  #       end
  #
  #       def self.list_class
  #         SomeOtherList
  #       end
  #     end
  #
  #     material_finder.class_for(Gaz.new) # => GazMaterial
  #     material_finder.class_for(Gaz) # => FooBarMaterial
  #     list_finder.class_for(Gaz.new) # => SomeOtherList
  #
  # Symbols and strings work as well, providing they can be camelized properly to a class:
  #
  #     material_finder.class_for("FooBar") # => FooBarMaterial
  #     material_finder.class_for("foo_bar") # => FooBarMaterial
  #     material_finder.class_for(:foo_bar) # => FooBarMaterial
  #     material_finder.class_for(:something_else) # => nil
  #
  # Expected use is to create an instance of this and store it as a class instance variable to facilitate lookups:
  #
  #     class Material::Base
  #       class << self
  #         def for(object)
  #           class_finder.class_for(object)
  #         end
  #
  #         private
  #
  #         def class_finder
  #           @_class_finder ||= Spicerack::ClassFinder.new("Material")
  #         end
  #       end
  #     end
  class ClassFinder < RootObject
    attr_reader :class_type

    class NotFoundError < StandardError; end

    def initialize(class_type)
      @class_type = class_type
    end

    def class_for!(object)
      class_for(object) or raise NotFoundError, "could not find `#{class_type}' for `#{object.inspect}'"
    end

    def class_for(object)
      call_on_instance_or_class(object, explicit_method_name) || "#{root_name(object)}#{class_type}".safe_constantize
    end

    private

    def explicit_method_name
      "#{class_type.underscore.to_sym}_class".to_sym
    end
    memoize :explicit_method_name

    def root_name(object)
      model_name = call_on_instance_or_class(object, :model_name)
      return model_name if model_name.present?

      case object
      when Class
        object.name
      when Symbol, String
        object.to_s.camelize
      else
        object.class.name.chomp("Class")
      end
    end

    def call_on_instance_or_class(object, method_name)
      return object.public_send(method_name) if object.respond_to?(method_name)

      object.class.public_send(method_name) if object.class.respond_to?(method_name)
    end
  end
end
