# frozen_string_literal: true

require "active_support/concern"

module Directive
  module ConfigDelegation
    extend ActiveSupport::Concern

    DEFAULT_CONFIGURATION_MODULE_NAME = "Configuration"

    module ClassMethods
      delegate :config, :configure, to: :_configuration_module

      private

      # Sets up delegation from a top-level class to a nested Configuration module.
      #
      # @example
      #   class SomeClass
      #     include Directive::ConfigDelegation
      #
      #     delegates_to_configuration
      #   end
      #
      #   module SomeClass::Configuration
      #     extend Directive
      #   end
      #
      #   SomeClass.config
      #   => returns SomeClass::Configuration.config
      #   SomeClass.configure do { |config| # config is the yielded config object from SomeClass::Configuration.configure }
      #
      # @param config_class [Directive] A module that extends Directive. Defaults to the module +YourGem::Configuration+
      def delegates_to_configuration(config_class = nil)
        @_configuration_module = config_class || "#{self}::#{DEFAULT_CONFIGURATION_MODULE_NAME}".constantize
      end

      def _configuration_module
        raise NoMethodError, "Configuration not set up for #{self}. Did you forget to call delegates_to_configuration?" if @_configuration_module.nil?

        @_configuration_module
      end
    end
  end
end
