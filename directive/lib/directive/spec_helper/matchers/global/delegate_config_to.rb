# frozen_string_literal: true

module Directive
  module SpecHelper
    module Matchers
      module Global
        # RSpec matcher to test options of a Configurable class
        #
        #     module MyGem
        #       include Directive::ConfigDelegation
        #       delegates_to_configuration
        #
        #       class MyGem::Configuration
        #         extend Directive
        #         ...
        #       end
        #     end
        #
        #     RSpec.describe ExampleConfiguration, type: :configuration do
        #       subject { described_class }
        #
        #       it { is_expected.to delegate_config_to MyGem::Configuration }
        #     end
        define :delegate_config_to do |config_module|
          attr_reader :obj, :config_module

          description { "delegates configuration methods to #{config_module}" }

          failure_message { "expected #{target} to delegate configuration methods to #{config_module}" }
          failure_message_when_negated { "expected #{target} not to delegate configuration methods to #{config_module}" }

          match_unless_raises do |obj|
            @obj = obj
            @config_module = config_module

            stub_configuration_methods

            expect(target.config).to eq config_return_value
            expect(target.configure).to eq configure_return_value
          end

          def target
            obj.is_a?(Module) ? obj : obj.class
          end

          def stub_configuration_methods
            allow(config_module).to receive(:config).and_return(config_return_value)
            allow(config_module).to receive(:configure).and_return(configure_return_value)
          end

          def config_return_value
            @config_return_value ||= double
          end

          def configure_return_value
            @configure_return_value ||= double
          end
        end
      end
    end
  end
end
