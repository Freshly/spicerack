# frozen_string_literal: true

module Spicerack
  module Objects
    module Status
      extend ActiveSupport::Concern

      included do
        after_validation { self.was_validated = errors.empty? }

        private

        attr_accessor :was_validated
      end

      def validated?
        was_validated.present?
      end
    end
  end
end
