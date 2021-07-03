# frozen_string_literal: true

module Tablesalt
  module ThreadAccessor
    module Management
      def written_thread_variables
        Thread.current[self::WRITTEN_VARIABLES_THREAD_KEY]
      end

      def register_written_thread_variable(name)
        Thread.current[self::WRITTEN_VARIABLES_THREAD_KEY] ||= Set.new
        Thread.current[self::WRITTEN_VARIABLES_THREAD_KEY] << name.to_sym
      end

      def clear_thread_variables!
        Thread.current[self::WRITTEN_VARIABLES_THREAD_KEY]&.each do |var|
          Thread.current[var] = nil
        end

        Thread.current[self::WRITTEN_VARIABLES_THREAD_KEY] = nil
      end

      # Cleans up thread variables written inside the yielded block
      #
      # @param :logger [Logger] Optional; A logger instance that implements the method :warn to send warning messages to
      # @yield block Yields no
      def with_isolated_thread_context(logger: nil)
        if ThreadAccessor.written_thread_variables.present?
          if logger.nil?
            puts "WARNING: ThreadAccessor variables set outside ThreadAccessor context: #{ThreadAccessor.written_thread_variables.join(", ")}"
          else
            logger.warn("ThreadAccessor variables set outside ThreadAccessor context: #{ThreadAccessor.written_thread_variables.join(", ")}")
          end
        end

        yield
      ensure
        ThreadAccessor.clear_thread_variables!
      end
    end
  end
end
