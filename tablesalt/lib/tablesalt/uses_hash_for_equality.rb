# frozen_string_literal: true

module Tablesalt
  module UsesHashForEquality
    extend ActiveSupport::Concern

    def ==(other)
      hash == other.hash
    end
    alias_method :eql?, :==
  end
end
