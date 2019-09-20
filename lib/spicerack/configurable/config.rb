# frozen_string_literal: true

require "around_the_world"
require "spicerack/input_object"

module Spicerack
  module Configurable
    class Config < InputObject
      include AroundTheWorld

      class << self
        def option(name, *args)
          super

          protect_option(name)
        end

        private

        def protect_option(name)
          around_method "#{name}=", prevent_double_wrapping_for: "Spicerack::Configurable" do |value|
            super dup_and_freeze(value)
          end
        end
      end

      private

      def dup_and_freeze(obj)
        duped_obj = obj.respond_to?(:deep_dup) ? obj.deep_dup : obj.dup
        deep_freeze(duped_obj)
      end

      def deep_freeze(obj)
        if obj.is_a?(Hash)
          obj.each { |_key, value| deep_freeze(value) }
        elsif obj.respond_to?(:each)
          obj.each { |item| deep_freeze(item) }
        end

        obj.freeze
      end
    end
  end
end
