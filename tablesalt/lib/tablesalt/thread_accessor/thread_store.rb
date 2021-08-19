# frozen_string_literal: true

require "active_support/hash_with_indifferent_access"

module Tablesalt
  module ThreadAccessor
    class ThreadStore
      delegate :==, to: :hash
      delegate_missing_to :hash

      def hash
        @hash ||= HashWithIndifferentAccess.new
      end
    end
  end
end
