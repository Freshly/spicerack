# frozen_string_literal: true

require_relative "around_the_world/errors"
require_relative "around_the_world/method_wrapper"
require_relative "around_the_world/proxy_module"
require_relative "around_the_world/version"
require "active_support/core_ext/object"
require "active_support/concern"
require "active_support/descendants_tracker"

module AroundTheWorld
  extend ActiveSupport::Concern

  included do
    extend ActiveSupport::DescendantsTracker
  end

  class_methods do
    protected

    # Defines a method that gets called +around+ the given instance method.
    #
    # @example
    #   class SomeClass
    #     around_method :dont_look_in_here do
    #       things_happened = super
    #
    #       if things_happened
    #         puts "Something happened!"
    #       else
    #         puts "Nothing to see here..."
    #       end
    #     end
    #
    #     def dont_look_in_here
    #       do_some_things
    #     end
    #   end
    #
    #   SomeClass.new.dont_look_in_here
    #   => "Something happened!"
    #
    # @example
    #   around_method :dont_look_in_here, prevent_double_wrapping_for: :memoization do
    #     @memoized ||= super
    #   end
    #
    #   around_method :dont_look_in_here, prevent_double_wrapping_for: :memoization do
    #     @memoized ||= super
    #   end
    #   # => AroundTheWorld::DoubleWrapError:
    #          "Module AroundTheWorld:ProxyModule:memoization already defines the method :dont_look_in_here"
    #
    #   around_method :dont_look_in_here do
    #     do_something_else
    #     super
    #   end
    #   # => no error raised
    #
    # @param method_name [Symbol]
    # @param :prevent_double_wrapping_for [Object]
    #   If defined, this prevents wrapping the method twice for a given purpose. Accepts any argument.
    def around_method(method_name, prevent_double_wrapping_for: nil, &block)
      MethodWrapper.wrap(
        method_name: method_name,
        target: self,
        prevent_double_wrapping_for: prevent_double_wrapping_for,
        &block
      )
    end
  end
end
