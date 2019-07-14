# frozen_string_literal: true

module Spicerack
  module Configurable
    class ConfigObject < InputObject
      include Singleton

      class_attribute :_nested_options, instance_writer: false, default: []
      class_attribute :_nested_builders, instance_writer: false, default: {}

      class << self
        def name
          super.presence || "#{superclass}:0x#{object_id.to_s(16)}"
        end

        def inspect
          "#<#{name}>"
        end

        private

        def nested(namespace, &block)
          nested_config_builder_for(namespace).tap do |builder|
            builder.instance_exec(&block)

            _nested_options << namespace
            define_method(namespace) { builder.__send__ :configuration }
          end
        end

        def nested_config_builder_for(namespace)
          _nested_builders[namespace.to_sym] ||= ConfigBuilder.new
        end
      end
    end
  end
end