# frozen_string_literal: true

module Collectible
  module Collection
    module Core
      extend ActiveSupport::Concern

      included do
        attr_reader :items

        delegate :name, to: :class, prefix: true
        delegate :to_a, :to_ary, :select, :map, :group_by, :partition, :as_json, to: :items
      end

      def initialize(*items)
        @items = items.flatten
      end

      def hash
        { class_name: class_name, items: items }.hash
      end
    end
  end
end
