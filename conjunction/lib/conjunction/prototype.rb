# frozen_string_literal: true

module Conjunction
  # A **Prototype** is a uniquely named Object with behavior which has been abstracted out into **Junction** classes.
  module Prototype
    extend ActiveSupport::Concern

    included do
      delegate :prototype_name, :prototype, :prototype!, to: :class
    end

    class_methods do
      def prototype!
        prototype or raise NameError, "#{prototype_name} is not defined"
      end

      def prototype
        prototype_name&.safe_constantize
      end

      def prototype_name
        try(:model_name)&.name || name
      end
    end
  end
end
