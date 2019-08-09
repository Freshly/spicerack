# frozen_string_literal: true

require "tablesalt/uses_hash_for_equality"

require_relative "concerns/adapter"
require_relative "concerns/default"
require_relative "concerns/callbacks"
require_relative "concerns/core"
require_relative "concerns/schema"
require_relative "concerns/identity"
require_relative "concerns/accessors"
require_relative "concerns/comparisons"
require_relative "concerns/predicates"
require_relative "concerns/insertions"
require_relative "concerns/deletions"
require_relative "concerns/enumerators"
require_relative "concerns/mutations"
require_relative "concerns/converters"
require_relative "concerns/counters"
require_relative "concerns/expiration"

module RedisHash
  class Base
    include Tablesalt::UsesHashForEquality

    include RedisHash::Adapter
    include RedisHash::Default
    include RedisHash::Callbacks
    include RedisHash::Core
    include RedisHash::Schema
    include RedisHash::Identity
    include RedisHash::Accessors
    include RedisHash::Comparisons
    include RedisHash::Predicates
    include RedisHash::Insertions
    include RedisHash::Deletions
    include RedisHash::Enumerators
    include RedisHash::Mutations
    include RedisHash::Converters
    include RedisHash::Counters
    include RedisHash::Expiration
  end
end
