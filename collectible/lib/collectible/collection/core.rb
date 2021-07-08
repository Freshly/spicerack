# frozen_string_literal: true

module Collectible
  module Collection
    #
    # Core logic for any collection based on Collectible::CollectionBase
    #
    module Core
      extend ActiveSupport::Concern

      included do
        attr_reader :items

        delegate :name, to: :class, prefix: true
        delegate :include?, :to_a, :to_ary, :select, :map, :group_by,
                 :partition, :as_json, :inspect, to: :items
      end

      #
      # @param items {Array<*>} a list of items in a new collection
      #
      def initialize(*items)
        @items = items.flatten
      end

      def hash
        { class_name: class_name, items: items }.hash
      end
    end
  end
end
