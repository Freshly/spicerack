# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/module"

require "short_circu_it"

require "tablesalt/stringable_object"
require "tablesalt/uses_hash_for_equality"

require "collectible/version"

require "collectible/collection"

#
# Top level namespace containing all Collectible specific classes and definitions
#
module Collectible
  #
  # A wrapper for gem specific errors
  #
  class Error < StandardError; end
  #
  # An error used when an item is not allowed in a collection. For example
  # when a proc validation of an item returned false
  # @see Collectible::Collection::Validators::WithProc
  #
  class ItemNotAllowedError < Error; end
  #
  # An error raised when some of the elements being added into collection
  # does not match the required type
  #
  class ItemTypeMismatchError < ItemNotAllowedError; end
  #
  # An error raised when calling specific methods on a collection which must maintain its order.
  # @see Collectible::Collection::MaintainSortOrder
  #
  class MethodNotAllowedError < Error; end
end
