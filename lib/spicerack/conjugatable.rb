# frozen_string_literal: true

module Spicerack
  # Expressible as a named **Paradigm** which joins together related concepts for a common purpose via **conjugation**.
  #
  # The "Conjunction-Junction" coding pattern encapsulates responsibility into a suite of objects loosely coupled into
  # a named paradigm supporting extensible cross reference and predictive lookup based on explicitly defined convention.
  #
  # Any class which is `Conjugatable` should obey the following rules:
  #
  #   1) By convention, its descendants should be have a unitary name (no suffix or prefix), singular in form.
  #       bad: **OrdersRecord**
  #       bad: **OrderModel**
  #       bad: **Orders**
  #      good: **Order**
  #
  #   2) It should only define data and methods salient only to the definition and management of its own state.
  #
  # Therefore, it is suggested you include on the base of your **ActiveModels** (usually as **ActiveRecords**).
  #
  #     class ApplicationRecord < ActiveRecord::Base
  #       include Spicerack::Conjugatable
  #     end
  #
  #     class Order < ApplicationRecord
  #       # ...
  #     end
  #
  # Descendants of `ApplicationRecord` can now be **conjugated** into the aggregate objects which define its behavior.
  # These aggregate objects are referred to as **Junctions**, identifying themselves by including `Spicerack::Junction`.
  #
  #     class Law::BaseLaw
  #       include Spicerack::Junction
  #
  #       suffixed_with "Law"
  #     end
  #
  #     class ApplicationLaw < BaseLaw; end
  #
  # Descendants are expected to follow established naming conventions; this `suffixed_with` defines the convention:
  #
  #     Given a `paradigm_name`, add the suffix "Law".
  #
  # Descendants of `ApplicationLaw` are expected to be **Conjunctions** between a `Law` and some `Conjugatable` object:
  #
  #     class OrderLaw < ApplicationLaw; end
  #
  # The `Conjugatable` object should be able to predict what a valid **Conjunction** would be:
  #
  #     Order.conjugate(ApplicationLaw) # => OrderLaw
  #
  # This only works with classes which can find a `conjunction_for` some given paradigm.
  #
  #     Order.conjugate(SomeClass)   # => nil
  #     Order.conjugate!(SomeClass)  # => raise TypeError
  #
  # All `Conjugatable` instances can explicitly define custom **Conjunctions** using `.conjoin`:
  #
  #     class Order < ApplicationRecord
  #       conjoin WeeklyOrderLaw
  #     end
  #
  # As expected, this will explicitly override the normal conjugation behavior with what has been specified:
  #
  #     Order.conjugate(ApplicationLaw) # => WeeklyOrderLaw
  #
  # IMPORTANT! This **and only this** class (no further descendents) obey the explicit remapping:
  #
  #     class Suborder < Order; end
  #
  #     SubOrder.conjugate(ApplicationLaw) # => SubOrderLaw
  #
  # It is also possible to define entirely custom junctions which apply their own naming conventions.
  #
  #     class FooJunction
  #       include Spicerack::Junction
  #
  #       class << self
  #         def junction_key
  #           :bar
  #         end
  #
  #         def paradigm_name
  #           name.demodulize
  #         end
  #
  #         private
  #
  #         def conjunction_name_for(paradigm_name)
  #           return "Bar::#{paradigm_name}" if paradigm_name[0] == "B"
  #
  #           "Gaz::#{paradigm_name}"
  #         end
  #       end
  #     end
  #
  # One effective side-effect of standardizing on the paradigm name is that conjugation becomes transitive.
  #
  #     class ApplicationFoo
  #       include Spicerack::Junction
  #
  #       prefixed_with "Foo"
  #     end
  #
  #     class OrderFoo; end
  #
  #     OrderLaw.conjugate(ApplicationFoo) # => OrderFoo
  #
  # It can also be used to go back to the base paradigm:
  #
  #     OrderLaw.paradigm # => Order
  module Conjugatable
    extend ActiveSupport::Concern

    included do
      class_attribute :explicit_conjunctions, instance_writer: false, default: {}

      delegate :paradigm_name, to: :class
    end

    class_methods do
      def paradigm_name
        try(:model_name).&name || name
      end

      def conjugate!(junction)
        conjunction_for(junction) || conjugate_junction_with_method(junction, :conjunction_for!)
      end

      def conjugate(junction)
        conjunction_for(junction) || conjugate_junction_with_method(junction, :conjunction_for)
      end

      def inherited(base)
        base.explicit_conjunctions = {}
        super
      end

      private

      def conjugate_junction_with_method(junction, method_name)
        raise TypeError, "#{junction} is not a valid junction" unless junction.respond_to?(method_name)

        junction.public_send(method_name, paradigm_name)
      end

      def conjunction_for(junction)
        raise TypeError, "#{junction} is not a valid junction" unless junction.respond_to?(:junction_key)

        explicit_conjunctions[junction.junction_key]
      end

      def conjoin(junction)
        raise TypeError, "#{junction} is not a valid junction" unless junction.respond_to?(:junction_key)

        explicit_conjunctions[junction.junction_key] = junction
      end
    end
  end
end
