# frozen_string_literal: true

module Technologic
  class Logger
    class << self
      def log(severity, event)
        return unless defined?(Rails)

        Rails.logger.public_send(severity) do
          event.data.transform_values { |value| format_value_for_log(value) }
        end
      end

      def format_value_for_log(value)
        # `#to_log_string` is idiomatic to Technologic and is the most explicit way to specify how an object is logged.
        return value.to_log_string if value.respond_to?(:to_log_string)

        return value.to_s if value.is_a?(Enumerator)
        return value if value.is_a?(Numeric)
        return value.id if value.respond_to?(:id)
        return value.transform_values { |element| format_value_for_log(element) } if value.respond_to?(:transform_values)
        return value.map { |element| format_value_for_log(element) } if value.respond_to?(:map)

        value.to_s
      end
    end
  end
end
