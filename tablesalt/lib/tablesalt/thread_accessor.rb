# frozen_string_literal: true

require "active_support/concern"
require "set"

require_relative "thread_accessor/management"
require_relative "thread_accessor/rack_middleware"

# WARNING: This module is still in beta mode and will likely change significantly soon. Tread carefully...
module Tablesalt
  module ThreadAccessor
    extend ActiveSupport::Concern
    extend Management

    WRITTEN_VARIABLES_THREAD_KEY = :__tablesalt_thread_accessor_written_variable_names__

    module ClassMethods
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
        define_method(method) { Thread.current[thread_key] }
        define_singleton_method(method) { Thread.current[thread_key] }

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
      #   {ThreadAccessor::RackMiddleware} or run {ThreadAccessor.clear_thread_variables!} manually once
      #   the thread is finished to avoid pollluting other requests.
      #
      # @param method [String, Symbol] The name of the writer method
      # @param thread_key [String, Symbol] The key to write to on Thread.current
      # @option :private [Boolean] If true, both defined methods will be private. Default: true
      def thread_writer(method, thread_key, **options)
        method_name = "#{method}="

        define_method(method_name) do |value|
          ThreadAccessor.register_written_thread_variable(thread_key)
          Thread.current[thread_key] = value
        end

        define_singleton_method(method_name) do |value|
          ThreadAccessor.register_written_thread_variable(thread_key)
          Thread.current[thread_key] = value
        end

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
