# frozen_string_literal: true

require "short_circu_it/version"
require "short_circu_it/errors"
require "short_circu_it/memoization_store"
require "active_support/core_ext/module"
require "active_support/core_ext/array"
require "active_support/concern"
require "around_the_world"

module ShortCircuIt
  extend ActiveSupport::Concern
  include AroundTheWorld

  included do
    delegate :memoization_observers, to: :class
    delegate :clear_memoization, :clear_all_memoization, to: :memoization_store
  end

  private

  # @return [ShortCircuIt::MemoizationStore]
  def memoization_store
    @memoization_store ||= MemoizationStore.new(self)
  end

  class_methods do
    def memoization_observers
      return _memoization_observers unless superclass.respond_to?(:memoization_observers)

      superclass.memoization_observers.merge(_memoization_observers)
    end

    protected

    # @example
    #   def expensive_method
    #     puts "doing some really expensive operation here!"
    #     "these datas are yuuge"
    #   end
    #   memoize :expensive_method
    #
    #   expensive_method
    #   doing some really expensive operation here!
    #   => "these datas are yuuge"
    #   expensive_method
    #   => "these datas are yuuge"
    #
    # @example
    #   def some_association
    #     SomeAssociation.find(some_association_id)
    #   end
    #   memoize :some_association, observes: :some_association_id
    #
    #   some_association_id = 1
    #   some_association
    #   * database stuff *
    #   => #<SomeAssociation:1234 id: 1>
    #
    #   some_association
    #   * no database stuff *
    #   => #<SomeAssociation:1234 id: 1>
    #
    #   some_association_id = 2
    #   some_association
    #   * database stuff *
    #   => #<SomeAssociation:2468 id: 2>
    #
    # @api public
    # @param *method_names [Symbol] The name(s) of one or more methods to be memoized
    # @param :observes [Symbol, Array<Symbol>]
    #   A method or array of methods to be observed to determine memoization cache validity.
    #   If any of the observed values change, the cached value will be invalidated.
    #   By default, the object will observe itself.
    def memoize(*method_names, observes: :itself)
      method_names.map(&:to_sym).each do |method_name|
        add_memoized_observers(method_name, observes)

        around_method(
          method_name,
          prevent_double_wrapping_for: ShortCircuIt,
        ) do |*args, **opts, &block|
          memoization_store.memoize(method_name, (args + [ opts, (block if block_given?) ]).hash) do
            # TODO: replace with `super(...)` when <= 2.6 support is dropped
            if RUBY_VERSION < "2.7" && opts.blank?
              super(*args, &block)
            else
              super(*args, **opts, &block)
            end
          end
        end
      end
    end

    private

    attr_writer :_memoization_observers

    def _memoization_observers
      @_memoization_observers ||= {}
    end

    def add_memoized_observers(method_name, observers)
      # TODO: Raise an error if method has already been memoized? A warning maybe?
      self._memoization_observers = _memoization_observers.
        merge(method_name.to_sym => Array.wrap(observers).freeze).
        freeze
    end
  end
end
