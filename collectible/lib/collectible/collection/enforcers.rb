# frozen_string_literal: true

require_relative "enforcers/base"
require_relative "enforcers/with_first_element"
require_relative "enforcers/with_proc"
require_relative "enforcers/with_type"

module Collectible
  module Collection
    #
    # A module containing collection specific validators
    #
    module Enforcers
      module_function

      # Factory method for building a validator of specific type
      # @param items {Array<*>} A list of existing items in collection
      # @param new_items {Array<*>} A list of items to be added to collection
      # @param validate_with Not used for this type of validator
      # @return {Collectible::Collection::Enforcers::WithFirstElement} an instance of validator
      #
      def with_first_element(items, new_items, validate_with: nil)
        WithFirstElement.new(items, new_items, validate_with: validate_with)
      end

      # Factory method for building a validator of specific type
      # @param items {Array<*>} A list of existing items in collection
      # @param new_items {Array<*>} A list of items to be added to collection
      # @param validate_with A proc for items to be validated against
      # @return {Collectible::Collection::Enforcers::WithProc} an instance of validator
      #
      def with_proc(items, new_items, validate_with:)
        WithProc.new(items, new_items, validate_with: validate_with)
      end

      # Factory method for building a validator of specific type
      # @param items {Array<*>} A list of existing items in collection
      # @param new_items {Array<*>} A list of items to be added to collection
      # @param validate_with A type (class) for items to be validated against
      # @return {Collectible::Collection::Enforcers::WithType} an instance of validator
      #
      def with_type(items, new_items, validate_with:)
        WithType.new(items, new_items, validate_with: validate_with)
      end
    end
  end
end
