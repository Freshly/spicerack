# frozen_string_literal: true

module Tablesalt
  module ThreadAccessor
    class ScopedAccessor < Module
      attr_reader :scope

      def initialize(scope)
        @scope = scope

        extend ActiveSupport::Concern
        extend Management
        include ThreadAccessor

        define_method(:__thread_accessor_scope__) { scope }
      end

      def name
        "#{self.class}:#{scope}"
      end

      def inspect
        "#<#{name}>"
      end
    end
  end
end
