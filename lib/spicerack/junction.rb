# frozen_string_literal: true

module Spicerack
  # Performs a predictive lookup for a "Conjoined Class" using a named **Paradigm**.
  module Junction
    extend ActiveSupport::Concern

    included do
      delegate :conjugate!, to: :paradigm!
    end

    class_methods do
      attr_reader :conjunction_suffix

      def conjugate(junction)
        paradigm.try(:conjugate, junction)
      end

      def paradigm!
        paradigm_name.constantize
      end

      def paradigm
        paradigm_name.safe_constantize
      end

      def paradigm_name
        name.chomp(conjunction_suffix)
      end

      def conjunction_for!(paradigm_name)
        conjunction_name_for(paradigm_name).constantize
      end

      def conjunction_for(paradigm_name)
        conjunction_name_for(paradigm_name).safe_constantize
      end

      def junction_key
        conjunction_suffix.underscore.to_sym
      end

      def conjunction_suffix?
        conjunction_suffix.present?
      end

      def inherited(base)
        base.suffixed_with(conjunction_suffix) if conjunction_suffix?
      end

      protected

      def suffixed_with(suffix)
        raise TypeError, "suffix must be a string" if suffix.present? && !suffix.is_a?(String)

        @conjunction_suffix = suffix
      end

      private

      def conjunction_name_for(paradigm_name)
        raise ArgumentError, "no conjunction_suffix has been defined!" unless conjunction_suffix?

        "#{paradigm_name}#{conjunction_suffix}"
      end
    end
  end
end
