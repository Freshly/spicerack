# frozen_string_literal: true

require_relative "collection/enforcers"

require_relative "collection/core"
require_relative "collection/wraps_collection_methods"
require_relative "collection/ensures_item_eligibility"
require_relative "collection/maintain_sort_order"
require_relative "collection/finder"

require_relative "collection_base"

module Collectible
  #
  # A namespace containing all Collection specific logic for validating and finding
  # an element in the collection to name a few.
  #
  module Collection
  end
end
