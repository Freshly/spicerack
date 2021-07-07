# frozen_string_literal: true

module Tablesalt
  module ThreadAccessor
    module Management
      def store
        Thread.current[Tablesalt::ThreadAccessor::STORE_THREAD_KEY] ||= ThreadStore.new
      end

      # Cleans up thread variables written inside the yielded block
      #
      # @param :logger [Logger] Optional; A logger instance that implements the method :warn to send warning messages to
      # @yield block Yields no
      def with_isolated_thread_context(logger: nil)
        if store.present?
          if logger.nil?
            puts "WARNING: ThreadAccessor variables set outside ThreadAccessor context: #{store.keys.join(", ")}"
          else
            logger.warn("ThreadAccessor variables set outside ThreadAccessor context: #{store.keys.join(", ")}")
          end
        end

        yield
      ensure
        store.clear
      end
    end
  end
end
