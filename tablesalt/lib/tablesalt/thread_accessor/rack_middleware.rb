# frozen_string_literal: true

module Tablesalt
  module ThreadAccessor
    class RackMiddleware
      def initialize(app)
        @app = app
      end

      # Clears thread variables after request is finished processing.
      # Make sure this middleware appears +before+ anything that may set
      # thread variables using ThreadAccessor
      def call(req)
        ThreadAccessor.clean_thread_context(logger: @app.logger) { @app.call(req) }
      end
    end
  end
end
