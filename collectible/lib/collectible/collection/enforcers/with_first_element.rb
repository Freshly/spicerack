# frozen_string_literal: true

module Collectible
  module Collection
    module Enforcers
      #
      # A validator class which is going to check any items added using the type of
      # the first item in collection. Works both upon initializing and upon adding
      # of new items.
      #
      class WithFirstElement < Base
        #
        # @raise Collectible::ItemTypeMismatchError in case an item with class
        #   different from the class of the first item is being added.
        # @return <Array{*}> a list of new items
        #
        def validate!
          new_items.each do |new_item|
            unless new_item.instance_of?(first_item.class)
              raise Collectible::ItemTypeMismatchError,
                    "item mismatch: #{first_item.inspect}, #{new_item.inspect}"
            end
          end

          new_items
        end

        private

        def first_item
          items.blank? ? new_items.first : items.first
        end
      end
    end
  end
end
