# frozen_string_literal: true

module Technologic
  class Logger
    class << self
      def log(severity, event)
        Rails.logger.public_send(severity) do
          event.data.transform_values { |value| format_value_for_log(value) }
        end
      end

      private

      def format_value_for_log(value)
        # `#to_log_string` is idiomatic to Technologic and is the most explicit way to specify how an object is logged.
        return value.to_log_string if value.respond_to?(:to_log_string)

        return value if value.is_a?(Numeric)
        return value.id if value.respond_to?(:id)
        return value.map { |mappable_value| format_value_for_log(mappable_value) } if value.respond_to?(:map)

        value.to_s
      end
    end
  end
end

# ActiveSupport::Notifications.subscribe(%r{\.fatal$}, FatalLogger.new)
# ActiveSupport::Notifications.subscribe(%r{\.error$}, ErrorLogger.new)
# ActiveSupport::Notifications.subscribe(%r{\.warn$}, WarnLogger.new)
# ActiveSupport::Notifications.subscribe(%r{\.info$}, InfoLogger.new)
# ActiveSupport::Notifications.subscribe(%r{\.debug$}, DebugLogger.new)
