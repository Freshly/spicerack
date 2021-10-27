# frozen_string_literal: true

require "active_model"
require "active_support/core_ext/object/inclusion"
require "substance/input_object"
require "tablesalt/stringable_object"

module Directive
  class ConfigObject < Substance::InputObject
    include Singleton
    include ActiveModel::AttributeAssignment

    alias_method :assign, :assign_attributes

    RESERVED_WORDS = %i[config_eval].freeze

    class_attribute :_nested_options, instance_writer: false, default: []
    class_attribute :_nested_builders, instance_writer: false, default: {}

    class << self
      private

      def option(name, *args, **kwargs)
        name = name.to_sym

        _ensure_safe_option_name(name)

        super(name, *args, **kwargs)
      end

      def nested(namespace, &block)
        namespace = namespace.to_sym

        _ensure_safe_option_name(namespace)

        nested_config_builder_for(namespace).tap do |builder|
          builder.instance_exec(&block)

          _nested_options << namespace
          define_method(namespace) do |&nested_configure_block|
            builder.__send__(:configuration).tap do |nested_config|
              nested_configure_block.call(nested_config) if nested_configure_block.respond_to?(:call)
            end
          end
        end
      end

      def nested_config_builder_for(namespace)
        _nested_builders[namespace.to_sym] ||= ConfigBuilder.new
      end

      def _ensure_safe_option_name(name)
        raise ArgumentError, "#{name.inspect} is reserved and cannot be used at a config option" if name.in?(RESERVED_WORDS)
        raise ArgumentError, "#{name.inspect} is defined twice" if _nested_options.include?(name)

        puts "Warning: the config option #{name} is already defined" if _options.include?(name) # rubocop:disable Rails/Output
      end

      def inherited(base)
        base._nested_options = _nested_options.dup
        base._nested_builders = _nested_builders.dup
        super
      end
    end

    def inspect
      "#<#{self.class.superclass} #{super}>"
    end
  end
end
