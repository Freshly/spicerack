# frozen_string_literal: true

# Comparisons encompasses equality and set inclusion.
module RedisHash
  module Comparisons
    extend ActiveSupport::Concern

    included do
      delegate :<, :<=, :>, :>=, :compare_by_identity, :compare_by_identity?, to: :to_h
    end
  end
end
