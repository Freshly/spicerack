# frozen_string_literal: true

module Tablesalt
  module ThreadAccessor
    module Management
      def store(namespace = nil)
        stores = Thread.current[Tablesalt::ThreadAccessor::THREAD_ACCESSOR_STORE_THREAD_KEY] ||= {}
        stores[namespace] ||= ThreadStore.new
      end

      # Cleans up ThreadAccessor state after given block executes
      #
      # @param :logger [Logger] Optional; A logger instance that implements the method :warn to send warning messages to
      # @yield Required; Yields no variables to the given block
      def clean_thread_context(logger: nil, namespace: nil)
        if store(namespace).present?
          if logger.nil?
            puts "WARNING: ThreadAccessor variables set outside ThreadAccessor context: #{store(namespace).keys.join(", ")}"
          else
            logger.warn("ThreadAccessor variables set outside ThreadAccessor context: #{store(namespace).keys.join(", ")}")
          end
        end

        yield
      ensure
        store(namespace).clear
      end
    end
  end
end
