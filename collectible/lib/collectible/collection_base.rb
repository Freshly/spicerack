# frozen_string_literal: true

module Collectible
  #
  # A class to inherit from for utilizing Collectible functionality in
  # a specific collection.
  # @abstract
  #
  class CollectionBase
    include ShortCircuIt

    include Tablesalt::StringableObject
    include Tablesalt::UsesHashForEquality

    include Collectible::Collection::Core
    include Collectible::Collection::WrapsCollectionMethods
    include Collectible::Collection::EnsuresItemEligibility
    include Collectible::Collection::MaintainSortOrder
    include Collectible::Collection::Finder
  end
end
