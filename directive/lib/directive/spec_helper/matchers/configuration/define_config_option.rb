# frozen_string_literal: true

module Directive
  module SpecHelper
    module Matchers
      module Configuration
        # RSpec matcher to test options of a Configurable class
        #
        #     class ExampleConfiguration
        #       extend Directive
        #
        #       option :foo
        #       option :bar, default: :baz
        #     end
        #
        #     RSpec.describe ExampleConfiguration, type: :configuration do
        #       subject { described_class.new }
        #
        #       it { is_expected.to define_config_option :foo }
        #       it { is_expected.to define_config_option :bar, default: :baz }
        #     end
        define :define_config_option do |option, default: nil|
          description { "define config option #{option.inspect}" }
          failure_message { "expected #{@obj} to define config option #{option.inspect} with default #{default.inspect}" }

          match do |obj|
            @obj = obj

            if obj.is_a? Directive::ConfigObject
              expect(obj).to define_option option, default: default
            else
              expect(obj).to respond_to :config
              expect(obj.config.instance_variable_get(:@config)).to be_present
              expect(obj.config.instance_variable_get(:@config)).to define_option option, default: default
            end
          end
        end
      end
    end
  end
end
