# frozen_string_literal: true

require_relative "directive/config_builder"
require_relative "directive/config_delegation"
require_relative "directive/config_object"
require_relative "directive/evaluator"
require_relative "directive/reader"

# NOTE: This is still a pre-release feature! Use at your own risk - it may change before being released.
#
# A utility for creating read-only gem configuration singletons.
#
# Usage:
#   # In your gem:
#   module SomeGem
#     module Configuration
#       extend Directive
#
#       configuration_options do
#         option :some_config_option
#         option :some_option_with_a_default, default: "I probably know what's best"
#
#         nested :whats_behind do
#           option :door_one, default: "It's a goat"
#           option :door_two, default: "Another goat"
#           option :door_three, default: "It's a car!"
#         end
#       end
#     end
#   end
#
#   # Then, in the application using the gem:
#   SomeGem::Configuration.configure do |config|
#     config.some_config_option = 12345
#     config.some_option_with_a_default = "Nope, you really don't"
#
#     config.whats_behind do |nested|
#       nested.door_one = "It's a boat!"
#       nested.door_three = "The teletubbies on repeat 😱"
#     end
#   end
#
#   # Then, back in your gem code:
#   puts Configuration.config.some_config_option
#   => 12345
#   puts Configuration.config.whats_behind.door_one
#   => "It's a boat!"
#
#   # Or, if you want to select dynamically:
#   doors = %i[door_one door_two door_three]
#   Configuration.config.config_eval(whats_behind, doors.sample).read
#   => "The teletubbies on repeat 😱"
module Directive
  delegate :configure, :config_eval, to: :_config_builder

  # @return [Directive::ConfigReader] A read-only object containing configuration options set inside {#configure}
  def config
    _config_builder.reader
  end

  # Run a callback before the configure block is evaluated.
  #
  # Note: if configure is called multiple times for your gem, this block will get run each time!
  #
  def before_configure(&block)
    _config_builder_class.set_callback(:configure, :before, &block)
  end

  # Run a callback after the configure block is evaluated.
  #
  # Note: if configure is called multiple times for your gem, this block will get run each time!
  #
  def after_configure(&block)
    _config_builder_class.set_callback(:configure, :after, &block)
  end

  private

  def configuration_options(&block)
    _config_builder.instance_exec(&block)
  end

  def _config_builder
    @_config_builder ||= _config_builder_class.new
  end

  def _config_builder_class
    @_config_builder_class ||= Class.new(ConfigBuilder).tap do |klass|
      const_set(:ConfigBuilder, klass)
    end
  end
end
