# frozen_string_literal: true

module Collectible
  module Collection
    module Enforcers
      #
      # A validator class which is going to check any items added using
      # the result of evaluating a passed Proc. Proc accepts a single argument
      # which is each new item from the list of new items.
      # An item is considered valid if Proc is evaluated to a truthy value (not nil or false)
      #
      class WithProc < Base
        #
        # @raise Collectible::ItemTypeMismatchError if a block returns a falsey
        #   value (`nil` or `false`)
        # @return {Array<*>} a list of new items
        #
        def validate!
          new_items.each do |new_item|
            #
            # @todo raise a different error here since type mismatch is not always the case
            #
            raise Collectible::ItemNotAllowedError unless validate_with.call(new_item)
          end

          new_items
        end
      end
    end
  end
end
