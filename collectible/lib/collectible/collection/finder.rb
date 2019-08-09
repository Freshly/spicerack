# frozen_string_literal: true

module Collectible
  module Collection
    module Finder
      extend ActiveSupport::Concern

      # @param attributes [Hash] A hash of arbitrary attributes to match against the collection
      # @return [*] The first item in the collection that matches the specified attributes
      def find_by(**attributes)
        find do |item|
          attributes.all? do |attribute, value|
            item.public_send(attribute) == value
          end
        end
      end

      # @param attributes [Hash] A hash of arbitrary attributes to match against the collection
      # @return [ApplicationCollection] A collection of all items in the collection that match the specified attributes
      def where(**attributes)
        select do |item|
          attributes.all? do |attribute, value|
            item.public_send(attribute) == value
          end
        end
      end
    end
  end
end
