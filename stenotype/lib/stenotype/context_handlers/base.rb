# frozen_string_literal: true

module Stenotype
  module ContextHandlers
    #
    # An abstract base class for implementing contexts handlers
    #
    # @abstract
    # @attr_reader {Object} context A context in which the event was emitted
    # @attr_reader {Hash} options A hash of additional options
    #
    # @example Defining a custom Handler
    #   class MyCustomHandler < Stenotype::ContextHandlers::Base
    #     self.context_name = :custom_handler
    #
    #     def as_json(*_args)
    #       {
    #         value1: context.value1,
    #         value2: context.value2
    #       }
    #     end
    #   end
    #
    class Base
      attr_reader :context, :options

      #
      # @param context {Object} A context where the event was emitted
      # @param options {Hash} A hash of additional options
      #
      # @return {#as_json} A context handler implementing [#as_json]
      #
      def initialize(context, options: {})
        @context = context
        @options = options
      end

      #
      # @abstract
      # @raise {NotImplementedError} subclasses must implement this method
      #
      def as_json(*_args)
        raise NotImplementedError, "#{self} must implement method ##{__method__}"
      end

      #
      # @attr_writer {Symbol} handler_name The name under which a handler is going to be registered
      #
      class << self
        # Handler name by which it will be registered in {Stenotype::ContextHandlers::Collection}
        attr_writer :handler_name

        #
        # @return {Symbol} Name of the handler
        # @raise {NotImplementedError} in case handler name is not specified.
        #
        def handler_name
          @handler_name || raise(NotImplementedError, "Please, specify the handler_name of #{self}")
        end
      end
    end
  end
end
