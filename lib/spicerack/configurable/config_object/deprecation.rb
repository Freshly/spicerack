# frozen_string_literal: true

require "around_the_world"
require "active_support/concern"
require "active_support/deprecation"

module Spicerack
  module Configurable
    class ConfigObject
      module Deprecation
        extend ActiveSupport::Concern
        include AroundTheWorld

        module ClassMethods
          # Deprecate a configuration option for another.
          #
          # Accepts a deprecated configuration option, its replacement configuration option
          # (whether it's a single configuration option or a path) and some details about the deprcation.
          #
          # When a configuration option is deprecated for another,
          # setting either value will overwrite the value of the other.
          #
          # @param name [String, Symbol] The name of the deprecated configuration option
          # @param :replace_with [String, Symbol, Array<String, Symbol>] The name of the replacement configuration option,
          #   or the path to a replacement nested configuration option in an array.
          # @param :gem_name [String, Symbol] The name of the library or gem in development
          # @param :deprecation_horizon [String] The version of the library at which this configuration option will be removed
          def deprecate_config(name, replace_with: nil, gem_name:, deprecation_horizon:)
            replacement_method_path = replace_with.is_a?(Array) ? replace_with.map(&:to_s).join(".") : replace_with
            _config_deprecation(gem_name, deprecation_horizon).
              deprecate_methods(name => replacement_method_path, "#{name}=" => "#{replacement_method_path}=")

            # TODO: Wrap reader and writer methods to use the replacement config.
            #       Must also account for defaults set on the old config var, as well as replacements in other
            #       nesting trees.
          end

          private

          def _config_deprecation(gem_name, deprecation_horizon)
            ActiveSupport::Deprecation.new(gem_name, deprecation_horizon)
          end
        end
      end
    end
  end
end
