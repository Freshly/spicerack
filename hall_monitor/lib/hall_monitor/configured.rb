# frozen_string_literal: true

module HallMonitor
  module Configured
    extend ActiveSupport::Concern

    included do
      delegate :configuration, to: :class
    end

    class_methods do
      protected

      def configuration
        HallMonitor.configuration
      end
    end
  end
end
