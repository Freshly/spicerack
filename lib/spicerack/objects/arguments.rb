# frozen_string_literal: true

# Arguments describe input that is required (which can be nil, unless otherwise specified).
module Spicerack
  module Objects
    module Arguments
      extend ActiveSupport::Concern

      included do
        class_attribute :_arguments, instance_writer: false, default: {}
        set_callback :initialize, :after do
          missing_arguments = _arguments.reject do |argument, options|
            options[:allow_nil] ? input.key?(argument) : !input[argument].nil?
          end

          missing = missing_arguments.keys

          raise ArgumentError, "Missing #{"argument".pluralize(missing.length)}: #{missing.join(", ")}" if missing.any?
        end
      end

      class_methods do
        def inherited(base)
          dup = _arguments.dup
          base._arguments = dup.each { |k, v| dup[k] = v.dup }
          super
        end

        private

        def argument(argument, output: false, allow_nil: true)
          _arguments[argument] = { allow_nil: allow_nil }
          _outputs << argument if output && respond_to?(:_outputs)
          define_attribute argument
        end
      end
    end
  end
end
