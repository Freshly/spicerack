# frozen_string_literal: true

module Collectible
  module Collection
    module Enforcers
      #
      # An abstract class for all validators to be inherited by
      # @abstract
      #
      class Base
        attr_reader :items, :new_items, :validate_with

        #
        # @param items {Array<*>} a list of existing in collection items
        # @param new_items {Array<*>} a list of items to be added to collection
        # @param validate_with {*} an optional argument which will depend on specific validator
        # @return {#validate!} An object implementing #validate! method
        #
        def initialize(items, new_items, validate_with: nil)
          @items = items
          @new_items = new_items.flatten
          @validate_with = validate_with
        end

        #
        # This method is expected to be implemented by subclasses
        # @abstract
        # @raise [NotImplementedError] unless implemented in a subclass
        #
        def validate!
          raise NotImplementedError, "#{self.class} must implement method #publish!"
        end
      end
    end
  end
end
