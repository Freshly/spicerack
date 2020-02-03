# frozen_string_literal: true

require "active_support"

require "spicerack"

require "conjunction/version"

require "conjunction/configuration"

require "conjunction/nexus"

require "conjunction/prototype"
require "conjunction/conjunctive"
require "conjunction/naming_convention"
require "conjunction/junction"

module Conjunction
  include Directive::ConfigDelegation
  delegates_to_configuration

  class Error < StandardError; end
  class DisjointedError < Error; end
end
