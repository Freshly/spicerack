# frozen_string_literal: true

module Collectible
  module Collection
    module EnsuresItemEligibility
      extend ActiveSupport::Concern

      ENSURE_TYPE_EQUALITY = :ENSURE_TYPE_EQUALITY

      included do
        ensure_item_validity_before :initialize, :push, :<<, :unshift, :insert, :concat, :prepend
      end

      delegate :item_class, to: :class

      private

      delegate :ensure_item_validity_with, to: :class

      # Raises an error if any items fail the class' item validity block/class
      def ensure_allowed_in_collection!(*new_items)
        ensure_type_equality!(*new_items) and return if ensures_type_equality?

        invalid_items = new_items.flatten.reject { |item| allows_item?(item) }
        return if invalid_items.empty?

        raise Collectible::ItemNotAllowedError,
              "not allowed: #{invalid_items.first(3).map(&:inspect).join(", ")}#{"..." if invalid_items.length > 3}"
      end

      # @param item [*]
      # @return [Boolean]
      def allows_item?(item)
        if ensure_item_validity_with.respond_to?(:call)
          instance_exec(item, &ensure_item_validity_with)
        elsif ensure_item_validity_with.present?
          item.class <= ensure_item_validity_with
        else
          true
        end
      end

      # @return [Boolean]
      def ensures_type_equality?
        ensure_item_validity_with == ENSURE_TYPE_EQUALITY
      end

      def ensure_type_equality!(*new_items)
        new_items = new_items.flatten
        first_item = items.blank? ? new_items.first : items.first

        new_items.each do |item|
          next if item.class == first_item.class

          raise Collectible::ItemTypeMismatchError, "item mismatch: #{first_item.inspect}, #{item.inspect}"
        end
      end

      class_methods do
        # @return [Class] The class or superclass of all items in the collection
        def item_class
          item_enforcement.is_a?(Class) ? item_enforcement : name.gsub(%r{Collection.*}, "").safe_constantize
        end

        # @return [Class, Proc] Either a class that all collection items must belong to,
        #                       or a proc that validates each item as it is inserted.
        def ensure_item_validity_with
          item_enforcement ||
            (superclass.ensure_item_validity_with if superclass.respond_to?(:ensure_item_validity_with, true))
        end

        protected

        # @example
        #   # Allows any item that responds to :even? with a truthy value
        #   allow_item { |item| item.even? }
        #
        # for block { |item| ... }
        # @yield [*] Yields each inserted item to the provided block. The item will only be allowed into
        #            the collection if the block resolves to a truthy value; otherwise, an error is raised.
        #            The block shares the context of the collection +instance+, not the class.
        def allow_item(&block)
          raise Collectible::TypeEnforcementAlreadyDefined if item_enforcement.present?
          raise ArgumentError, "must provide a block" unless block_given?

          self.item_enforcement = block
        end

        # @example
        #   # Allows any item where item.class <= TargetDate
        #   ensures_item_class TargetDate
        #
        # @param klass [Class] A specific class all items are expected to be. Items of this type will be
        #                      allowed into collection; otherwise, an error is raised.
        def ensures_item_class(klass)
          raise Collectible::TypeEnforcementAlreadyDefined if item_enforcement.present?

          self.item_enforcement = klass
        end

        # Allows any object initially, but any subsequent item must be of the same class
        #
        # @example
        #   collection << Meal.first
        #   => #<ApplicationCollection items: [ #<Meal id: 1> ]
        #
        #   collection << User.first
        #   => Collectible::ItemNotAllowedError: not allowed: #<User id: 1>
        def ensures_type_equality
          raise Collectible::TypeEnforcementAlreadyDefined if item_enforcement.present?

          self.item_enforcement = ENSURE_TYPE_EQUALITY
        end

        # Inserts a check before each of the methods provided to validate inserted objects
        #
        # @param *methods [Array<Symbol>]
        def ensure_item_validity_before(*methods)
          methods.each do |method_name|
            around_method(method_name, prevent_double_wrapping_for: "EnsureItemValidity") do |*items|
              ensure_allowed_in_collection!(items)

              super(*items)
            end
          end
        end

        attr_internal_accessor :item_enforcement
        private :item_enforcement, :item_enforcement=
      end
    end
  end
end
