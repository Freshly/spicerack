# frozen_string_literal: true

require_relative "matchers"

module Directive
  module SpecHelper
    module DSL
      def nested_config_option(config_name, &block)
        in_nested_config_stack(config_name) do |nested_stack|
          describe(config_name.to_s, caller: caller) do
            subject { nested_config }

            let(:parent_config) { parent_config_for_nested(nested_stack) }
            let(:nested_config) { parent_config.public_send(nested_stack.last) }

            it "defines nested config object #{config_name}" do
              expect(parent_config).to respond_to config_name
              expect(parent_config._nested_options).to include config_name.to_sym
              expect(parent_config.public_send(config_name)).to be_a Directive::ConfigObject
            end

            instance_eval(&block)
          end
        end
      end

      def self.included(base)
        base.extend DSL
        super
      end

      private

      def parent_config_for_nested(nested_stack)
        @parent_config ||= {}

        @parent_config[nested_stack] ||= described_class.
          __send__(:_config_builder).
          __send__(:configuration).
          yield_self do |config|
            nested_stack[0..-2].inject(config) do |conf, nested_name|
              conf.public_send(nested_name)
            end
          end
      end

      def in_nested_config_stack(name)
        _nested_config_stack << name.to_sym

        yield _nested_config_stack.dup

        _nested_config_stack.pop
      end

      def _nested_config_stack
        Thread.current[:nested_config_stack] ||= []
      end
    end
  end
end
