# frozen_string_literal: true

require_relative "collection/core"
require_relative "collection/wraps_collection_methods"
require_relative "collection/ensures_item_eligibility"
require_relative "collection/maintain_sort_order"
require_relative "collection/finder"

module Collectible
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
