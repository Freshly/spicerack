# frozen_string_literal: true

# Attributes are structured data within an object.
module Spicerack
  module Objects
    module Attributes
      extend ActiveSupport::Concern

      included do
        class_attribute :_attributes, instance_writer: false, default: []
      end

      class_methods do
        def inherited(base)
          base._attributes = _attributes.dup
          super
        end

        private

        def define_attribute(attribute)
          _attributes << attribute
          attr_accessor attribute
        end
        alias_method :attribute, :define_attribute
      end

      def to_h
        _attributes.each_with_object({}) { |attr, hash| hash[attr] = public_send(attr) }
      end

      private

      def stringable_attributes
        self.class._attributes
      end
    end
  end
end
