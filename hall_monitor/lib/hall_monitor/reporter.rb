# frozen_string_literal: true

module HallMonitor
  class Reporter
    include Configured

    class << self
      def report!(redis_key, reported_arguments)
        new(redis_key, reported_arguments).report!
      end
    end

    attr_reader :redis_key, :reported_arguments

    def initialize(redis_key, reported_arguments)
      @redis_key = redis_key
      @reported_arguments = reported_arguments
    end

    def report!
      return unless redis_key_exists?

      # Report it!
    end

    private

    delegate :redis, to: :configuration

    def redis_key_exists?
      redis.hexists(redis_key)
    end
  end
end
