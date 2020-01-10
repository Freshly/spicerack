# frozen_string_literal: true

module Conjunction
  # **Conjunctives** are **Prototypes** that can be `conjugated` with a **Junction** into a specific **Conjunction**.
  module Conjunctive
    extend ActiveSupport::Concern

    include Conjunction::Prototype

    included do
      class_attribute :explicit_conjunctions, instance_writer: false, default: {}

      delegate :conjugate, :conjugate!, to: :class
    end

    class_methods do
      def conjugate(junction)
        conjugate_with(junction, :conjunction_for)
      end

      def conjugate!(junction)
        conjugate_with(junction, :conjunction_for!)
      end

      def inherited(base)
        base.explicit_conjunctions = {}
        super
      end

      private

      def conjugate_with(junction, method_name)
        conjunction = explicit_conjunctions[junction.try(:junction_key)] || Nexus.conjugate(self, junction: junction)
        return conjunction if conjunction.present?

        return if Conjunction.config.nexus_use_disables_implicit_lookup && Nexus.couples?(junction)

        junction.try(method_name, prototype, prototype_name) unless Conjunction.config.disable_all_implicit_lookup
      end

      def conjoins(junction)
        raise TypeError, "#{junction} is not a valid junction" unless junction.respond_to?(:junction_key)

        explicit_conjunctions[junction.junction_key] = junction
      end
    end
  end
end
