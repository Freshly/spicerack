# frozen_string_literal: true

module Collectible
  module Collection
    #
    # A module for wrapping collection methods with validation
    #
    module EnsuresItemEligibility
      extend ActiveSupport::Concern

      included do
        ensure_item_validity_before :initialize, :push, :<<, :unshift,
                                    :insert, :concat, :prepend

        delegate :item_enforcer, :enforce_with, to: :class

        cattr_accessor :item_enforcer
        cattr_accessor :enforce_with

        private

        #
        # @param *new_items {Array<*>} A collection of items to be validated before
        #   adding them to collection
        # @raise {Collectible::ItemTypeMismatchError} if one or more items does
        #   not match the required type
        #
        def ensure_allowed_in_collection!(*new_items)
          case item_enforcer
          when :enforce_first_element_type
            Enforcers.with_first_element(items, new_items, validate_with: enforce_with).validate!
          when :enforce_type
            Enforcers.with_type(items, new_items, validate_with: enforce_with).validate!
          when enforce_with.respond_to?(:call)
            Enforcers.with_proc(items, new_items, validate_with: enforce_with).validate!
          else
            true
          end
        end
      end

      class_methods do
        # :nodoc:
        def inherited(klass)
          klass.cattr_accessor :item_enforcer
          klass.cattr_accessor :enforce_with

          # Default behavior is to validate by first element
          klass.validate_elements :enforce_first_element_type

          super
        end

        #
        # @param item_enforcer {Symbol} the name of enforcer
        # @param with {Proc} optional callable object to validate each new item with
        #
        def validate_elements(validator, with: nil)
          self.item_enforcer = validator
          self.enforce_with = with
        end

        # Inserts a check before each of the methods provided to validate inserted objects
        #
        # @param *methods [Array<Symbol>]
        #
        def ensure_item_validity_before(*methods)
          methods.each do |method_name|
            around_method(method_name, prevent_double_wrapping_for: "EnsureItemValidity") do |*items|
              ensure_allowed_in_collection!(items)

              super(*items)
            end
          end
        end
      end
    end
  end
end
