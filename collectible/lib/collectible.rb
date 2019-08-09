# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/module"

require "short_circu_it"

require "tablesalt/stringable_object"
require "tablesalt/uses_hash_for_equality"

require "collectible/version"

require "collectible/collection_base"

module Collectible
  class ItemNotAllowedError < StandardError; end
  class ItemTypeMismatchError < ItemNotAllowedError; end
  class TypeEnforcementAlreadyDefined < StandardError; end
  class MethodNotAllowedError < StandardError; end
end
