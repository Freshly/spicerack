# frozen_string_literal: true

module Conjunction
  # A **Junction** is an encapsulation of behavior which has been abstracted out of a **Conjunctive**.
  module Junction
    extend ActiveSupport::Concern

    include Conjunction::Conjunctive
    include Conjunction::NamingConvention

    included do
      delegate :conjunction_for!, :conjunction_for, :conjunction_name_for, to: :class
    end

    class_methods do
      def junction_key
        key_parts.join.underscore.parameterize(separator: "_").to_sym if conjunctive?
      end

      def prototype_name
        output = name
        output.slice!(conjunction_prefix) if conjunction_prefix?
        output.chomp!(conjunction_suffix) if conjunction_suffix?
        output unless output == name
      end

      def conjunction_for!(other_prototype, prototype_name)
        conjunction_for(other_prototype, prototype_name) or raise DisjointedError, "#{other_prototype} #{name} unknown"
      end

      def conjunction_for(other_prototype, prototype_name)
        conjunction_name_for(other_prototype, prototype_name)&.safe_constantize
      end

      private

      def key_parts
        [ conjunction_prefix, conjunction_suffix ].compact
      end

      def conjunction_name_for(other_prototype, other_prototype_name)
        other_prototype_name = other_prototype.prototype_name if other_prototype.respond_to?(:prototype_name)
        return if other_prototype_name.blank?

        [ conjunction_prefix, other_prototype_name, conjunction_suffix ].compact.join if conjunctive?
      end
    end
  end
end
