# frozen_string_literal: true

module Conjunction
  # The Nexus provides a central source to couple objects together explicitly:
  #
  #     class Conjunction::Nexus
  #       couple Foo, to: CommonMaterial
  #       couple Bar, to: CommonMaterial
  #
  #       couple FooFlow, to: FooState, bidirectional: true
  #     end
  #
  class Nexus
    include Singleton

    class_attribute :_couplings, instance_writer: false, default: Hash.new { |hash, key| hash[key] = {} }

    class << self
      def conjugate(conjunctive, junction:)
        _couplings[junction.try(:junction_key)][conjunctive] if couples?(junction)
      end

      def couples?(junction)
        _couplings.key?(junction.try(:junction_key))
      end

      private

      def couple(conjunctive, to:, bidirectional: false)
        raise TypeError, "#{conjunctive} is not a valid conjunctive" unless conjunctive.respond_to?(:conjugate)
        raise TypeError, "#{to} is not a valid junction" unless to.respond_to?(:junction_key)

        if bidirectional
          raise TypeError, "#{conjunctive} is not a valid junction" unless conjunctive.respond_to?(:junction_key)

          _couplings[conjunctive.junction_key][to] = conjunctive
        end

        _couplings[to.junction_key][conjunctive] = to
      end
    end
  end
end
