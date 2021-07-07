# frozen_string_literal: true

module Tablesalt
  module ThreadAccessor
    module StoreInstance
      private

      # Internal method used for thread store scoping
      def __thread_accessor_namespace__; end

      def __thread_accessor_store_instance__
        ThreadAccessor.store(__thread_accessor_namespace__)
      end
    end
  end
end
