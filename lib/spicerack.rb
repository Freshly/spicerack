# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/class/attribute"
require "active_support/core_ext/object/inclusion"

require "spicerack/version"

require "tablesalt"

require "around_the_world"
require "short_circu_it"
require "technologic"

require "redis_hash"

require "spicerack/array_index"
require "spicerack/hash_model"
require "spicerack/redis_model"
require "spicerack/root_object"
require "spicerack/attribute_object"
require "spicerack/input_object"
require "spicerack/input_model"
require "spicerack/configurable"
require "spicerack/output_object"

module Spicerack
  class Error < StandardError; end
  class NotValidatedError < Error; end
end
