# frozen_string_literal: true

module Collectible
  module Collection
    #
    # A module for wrapping collection method with callbacks
    # allowing to maintain collection's order
    #
    module MaintainSortOrder
      extend ActiveSupport::Concern

      included do
        delegate :maintain_sort_order?, to: :class

        disallow_when_sorted :insert, :unshift, :prepend
        maintain_sorted_order_after :initialize, :push, :<<, :concat
      end

      # rubocop:disable Metrics/BlockLength
      class_methods do
        def inherited(base)
          base.maintain_sort_order if maintain_sort_order?
          super
        end

        def maintain_sort_order?
          @maintain_sort_order.present?
        end

        protected

        def maintain_sort_order
          @maintain_sort_order = true
        end

        private

        def maintain_sorted_order_after(*methods)
          methods.each do |method_name|
            around_method(method_name, prevent_double_wrapping_for: "MaintainSortingOrder") do |*items|
              super(*items).tap do
                sort! if maintain_sort_order?
              end
            end
          end
        end

        def disallow_when_sorted(*methods)
          methods.each do |method_name|
            around_method(method_name, prevent_double_wrapping_for: "MaintainSortingOrder") do |*args, **opts, &block|
              raise Collectible::MethodNotAllowedError, "cannot call #{method_name} when sorted" if maintain_sort_order?

              # TODO: replace with `super(...)` when <= 2.6 support is dropped
              if RUBY_VERSION < "2.7" && opts.blank?
                super(*args, &block)
              else
                super(*args, **opts, &block)
              end
            end
          end
        end
      end
      # rubocop:enable Metrics/BlockLength
    end
  end
end
