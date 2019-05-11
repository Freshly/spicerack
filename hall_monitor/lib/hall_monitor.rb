# frozen_string_literal: true

require "active_support/core_ext/module/delegation"
require "active_support/concern"
require "redis"
require "around_the_world"
require "hall_monitor/version"
require "hall_monitor/configuration"
require "hall_monitor/configured"
require "hall_monitor/monitor"
require "hall_monitor/monitor_job"

module HallMonitor
  extend ActiveSupport::Concern
  include AroundTheWorld

  class_methods do
    def monitor_calls_to(method_name, wait: Configuration.default_wait_time, queue_name: Configuration.queue_name)
      around_method(method_name, prevent_double_wrapping_for: HallMonitor) do |*args|
        Monitor.watch(method_name, args, wait: wait, queue_name: queue_name) do
          super(*args)
        end
      end
    end
  end

  class << self
    def redis
      @redis ||= Redis.new url: Configuration.redis_url,
                           db: Configuration.redis_db,
                           namespace: Configuration::REDIS_NAMESPACE
    end

    def reset_redis_connection!
      @redis = nil
    end
  end
end
