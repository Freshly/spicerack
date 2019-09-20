# frozen_string_literal: true

require_relative "configurable/config_builder"
require_relative "configurable/config"
require_relative "configurable/reader"

# NOTE: This is still a pre-release feature! Use at your own risk - it may change before being released.
#
# A utility for creating read-only gem configuration singletons.
#
# Usage:
#   # In your gem:
#   module SomeGem
#     module Configuration
#       extend Spicerack::Configurable
#
#       configuration_options do
#         option :some_config_option
#         option :some_option_with_a_default, default: "I probably know what's best"
#       end
#     end
#   end
#
#   # Then, in the application using the gem:
#   SomeGem::Configuration.configure do |config|
#     config.some_config_option = 12345
#     config.some_option_with_a_default = "Nope, you really don't"
#   end
#
#   # Then, back in your gem code:
#   puts Configuration.config.some_config_option
#   => 12345
module Spicerack
  module Configurable
    delegate :configure, to: :_config_builder

    def config
      _config_builder.reader
    end

    private

    def configuration_options(&block)
      _config_builder.instance_exec(&block)
    end

    def _config_builder
      @_config_builder ||= ConfigBuilder.new
    end
  end
end
