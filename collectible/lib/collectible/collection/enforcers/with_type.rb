# frozen_string_literal: true

module Collectible
  module Collection
    module Enforcers
      #
      # A validator class which is going to check if all items being added
      # are instance of the given type
      #
      class WithType < Base
        #
        # @raise Collectible::ItemTypeMismatchError if items is not instance of a given class
        # @return {Array<*>} a list of new items
        #
        def validate!
          WithProc.new(items, new_items, validate_with: validation_proc).validate!

          new_items
        end

        private

        def validation_proc
          lambda do |new_item|
            raise Collectible::ItemTypeMismatchError unless new_item.instance_of?(validate_with)

            new_item
          end
        end
      end
    end
  end
end
