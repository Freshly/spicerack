# frozen_string_literal: true

module Tablesalt
  module ThreadAccessor
    class ThreadStore
      delegate :==, to: :hash
      delegate_missing_to :hash

      def hash
        @hash ||= {}
      end
    end
  end
end
