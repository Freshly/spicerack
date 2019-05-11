# frozen_string_literal: true

require "active_job"

module HallMonitor
  class MonitorJob < (const_defined?("ApplicationJob") ? ApplicationJob : ActiveJob::Base)
    def perform(redis_key, reported_arguments)
      Reporter.report!(redis_key, reported_arguments)
    end
  end
end
