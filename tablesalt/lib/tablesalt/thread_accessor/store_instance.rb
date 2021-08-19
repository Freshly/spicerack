# frozen_string_literal: true

module Tablesalt
  module ThreadAccessor
    module StoreInstance
      private

      def __thread_accessor_store_instance__
        ThreadAccessor.store(respond_to?(:const_get) ? self::THREAD_ACCESSOR_STORE_NAMESPACE : self.class::THREAD_ACCESSOR_STORE_NAMESPACE)
      end
    end
  end
end
