# frozen_string_literal: true

module HallMonitor
  class Monitor
    include Configured

    REDIS_KEY = "passes"

    class << self
      def watch(method_name, args, wait:, queue_name:, &block)
        new(method_name, args, wait, queue_name).watch(&block)
      end
    end

    attr_reader :method_name, :args, :wait, :queue_name

    def initialize(method_name, args, wait, queue_name)
      @method_name = method_name
      @args = args
      @wait = wait
      @queue_name = queue_name
    end

    def watch
      set_redis_key
      enqueue_monitor_job

      yield
    ensure
      clear_redis_key
    end

    private

    delegate :redis, to: :configuration

    def enqueue_monitor_job
      MonitorJob.
        set(wait: wait, queue: queue_name).
        perform_later(method_name)
    end

    def set_redis_key
      puts "setting redis key"
      redis.hset(REDIS_KEY, hash, true)
    end

    def clear_redis_key
      puts "clearing redis key"
      redis.hdel(REDIS_KEY, hash)
    end
  end
end
