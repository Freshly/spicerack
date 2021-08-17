# frozen_string_literal: true

require "active_support/concern"
require "active_support/core_ext/module/delegation"

require_relative "thread_accessor/management"
require_relative "thread_accessor/rack_middleware"
require_relative "thread_accessor/scoped_accessor"
require_relative "thread_accessor/store_instance"
require_relative "thread_accessor/thread_store"

# WARNING: This module is still in beta mode and will likely change significantly soon. Tread carefully...
module Tablesalt
  module ThreadAccessor
    extend ActiveSupport::Concern
    extend Management

    STORE_THREAD_KEY = :__tablesalt_thread_accessor_store__

    include StoreInstance

    class << self
      # @example
      #   module MyGem
      #     class MyClass
      #       include Tablesalt::ThreadAccessor[:my_gem]
      #
      #       # Stored in a separate thread store for :my_gem, safe from mischievous app developers
      #       thread_accessor :foo, :my_foo
      #     end
      #   end
      #
      # @param scope [String, Symbol] A namespace for the thread variables
      # @return [Module] A ThreadAccessor module to be included into your class
      def [](scope)
        @scoped_accessors ||= {}
        @scoped_accessors[scope] ||= ScopedAccessor.new(scope)
      end
    end

    module ClassMethods
      include StoreInstance

      private

      # Defines an instance method and a singleton method to read from a given key in Thread.current
      #
      # @example
      #   class SomeClass
      #     include Tablesalt::ThreadAccessor
      #
      #     thread_reader :current_foo, :foo, private: false
      #   end
      #
      #   Thread.current[:foo] = "bar"
      #   SomeClass.current_foo
      #   => "bar"
      #
      #   SomeClass.new.current_foo
      #   => "bar"
      #
      # @param method [String, Symbol] The name of the reader method
      # @param thread_key [String, Symbol] The key to read from Thread.current
      # @option :private [Boolean] If true, both defined methods will be private. Default: true
      def thread_reader(method, thread_key, **options)
        define_method(method) { __thread_accessor_store_instance__[thread_key] }
        define_singleton_method(method) { __thread_accessor_store_instance__[thread_key] }

        return unless options.fetch(:private, true)

        private method
        private_class_method method
      end

      # Defines an instance method and a singleton method to write to a given key in Thread.current
      #
      # @example
      #   class SomeClass
      #     include Tablesalt::ThreadAccessor
      #
      #     thread_writer :current_foo, :foo, private: false
      #   end
      #
      #   SomeClass.current_foo = "bar"
      #
      #   Thread.current[:foo]
      #   => "bar"
      #
      # Note::
      #   All written thread variables are tracked on-thread, but will not be automatically cleared when
      #   the thread is done processing a request/unit of work. Make sure to either use the provided
      #   {ThreadAccessor::RackMiddleware} or run {ThreadAccessor.clean_thread_context} manually once
      #   the thread is finished to avoid pollluting other requests.
      #
      # Gem Authors::
      #   Thread variables should ideally be kept in a namespaced store instead of the global one. This means
      #   you are responsible for clearing your own store - either add your own middleware or advise users how
      #   to clear the thread store themselves.
      #
      # @param method [String, Symbol] The name of the writer method
      # @param thread_key [String, Symbol] The key to write to on Thread.current
      # @option :private [Boolean] If true, both defined methods will be private. Default: true
      def thread_writer(method, thread_key, **options)
        method_name = "#{method}="

        define_method(method_name) { |value| __thread_accessor_store_instance__[thread_key] = value }
        define_singleton_method(method_name) { |value| __thread_accessor_store_instance__[thread_key] = value }

        return unless options.fetch(:private, true)

        private method_name
        private_class_method method_name
      end

      # Defines instance methods and singleton methods to read/write a given key in Thread.current
      #
      # @example
      #   class SomeClass
      #     include Tablesalt::ThreadAccessor
      #
      #     thread_accessor :current_foo, :foo, private: false
      #   end
      #
      #   SomeClass.current_foo = "bar"
      #   SomeClass.current_foo
      #   => "bar"
      #
      #   SomeClass.new.current_foo = "baz"
      #   SomeClass.new.current_foo
      #   => "baz"
      #
      #   Thread.current[:foo]
      #   => "baz"
      #
      # @param method [String, Symbol] The name of the writer method
      # @param thread_key [String, Symbol] The key to write to on Thread.current
      # @option :private [Boolean] If true, all defined methods will be private. Default: true
      def thread_accessor(method, thread_key, **options)
        thread_reader(method, thread_key, **options)
        thread_writer(method, thread_key, **options)
      end
    end
  end
end
