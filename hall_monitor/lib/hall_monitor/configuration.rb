# frozen_string_literal: true

module HallMonitor
  Configuration = Struct.new(:default_wait_time, :redis_url, :redis_db, :queue_name) do
    DEFAULTS = {
      default_wait_time: (5 * 60),
      queue_name: :default,
    }.freeze

    REDIS_NAMESPACE = "hall_monitor"

    class << self
      delegate :default_wait_time, :redis_url, :redis_db, :queue_name, to: :configuration

      def configure
        HallMonitor.reset_redis_connection!

        yield configuration
      end

      private

      def configuration
        @configuration ||= new
      end
    end

    def queue_name
      @queue_name || DEFAULTS[:queue_name]
    end
  end

  class << self
    def configuration
      Configuration
    end
  end
end
