# frozen_string_literal: true

require "active_support"
require "short_circu_it"

require_relative "tablesalt/version"

require_relative "tablesalt/class_pass"
require_relative "tablesalt/dsl_accessor"
require_relative "tablesalt/isolation"
require_relative "tablesalt/stringable_object"
require_relative "tablesalt/thread_accessor"
require_relative "tablesalt/uses_hash_for_equality"

module Tablesalt; end
