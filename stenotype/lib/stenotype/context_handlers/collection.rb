# frozen_string_literal: true

module Stenotype
  module ContextHandlers
    #
    # A class representing a list of available context handlers
    # @example Complete usage overview
    #   class MyCustomHander
    #     self.handler_name = :custom_handler
    #
    #     def as_json(*_args)
    #       {
    #         key: :value
    #       }
    #     end
    #   end
    #
    #   collection = Stenotype::ContextHandlers::Collection.new
    #   collection.register(MyCustomHandler)
    #
    #   collection.registered?(MyCustomHandler) #=> true
    #   collection.choose(handler_name: :custom_handler) #=> MyCustomHandler
    #   collection.unregister(MyCustomHandler)
    #   collection.registered?(MyCustomHandler) #=> false
    #
    #   collection.register(SomeRandomClass) #=> ArgumentError
    #   collection.unregister(SomeRandomClass) #=> ArgumentError
    #   collection.choose(handler_name: :unknown) #=> Stenotype::UnknownHandlerError
    #
    class Collection < ::Collectible::CollectionBase
      #
      # Return a handler with given handler_name if found in collection,
      # raises if a handler is not registered
      #
      # @param handler_name {Symbol} a handler to be found in the collection
      # @raise {Stenotype::Errors::UnknownHandler} in case a handler is not registered
      # @return {#as_json} A handler which respond to #as_json
      #
      # @example When a handler is present in the collection
      #   collection = Stenotype::ContextHandlers::Collection.new
      #   collection.register(MyCustomHandler) # with handler_name = :custom_handler
      #   collection.choose(handler_name: :custom_handler) #=> MyCustomHandler
      #
      # @example When a handler is not present in the collection
      #   collection = Stenotype::ContextHandlers::Collection.new
      #   collection.choose(handler_name: :custom_handler) #=> MyCustomHandler
      #
      def choose(handler_name:)
        handler = find_by(handler_name: handler_name)
        handler || raise(
          Stenotype::UnknownHandlerError,
          "Handler '#{handler_name}' is not found. "\
          "Please make sure the handler you've specified is "\
          "registered in the list of known handlers. "\
          "See #{Stenotype::ContextHandlers} for more information.",
        )
      end

      #
      # @!method register(handler)
      #   Registers a new handler.
      #   @!scope instance
      #   @param handler {#as_json} a new handler to be added to collection
      #   @return {Stenotype::ContextHandlers::Collection} a collection object
      #   @example Registering a new handler
      #     collection = Stenotype::ContextHandlers::Collection.new
      #     collection.register(MyCustomHandler) # with handler_name = :custom_handler
      #
      alias_method :register, :push

      #
      # Removes a registered handler.
      #
      # @example Register and unregister a handler
      #   collection = Stenotype::ContextHandlers::Collection.new
      #   collection.register(MyCustomHandler) # with handler_name = :custom_handler
      #   collection.unregister(MyCustomHandler) # removes MyCustomHandler from the list of handlers
      #
      # @param handler {#as_json} a handler to be removed from the collection of known handlers
      # @return {Stenotype::ContextHandlers::Collection} a collection object
      #
      # @todo Add delete to the collectible delegation list
      #   and then use `alias_method :unregister, :delete`
      def unregister(handler)
        items.delete(handler)
        self
      end

      #
      # @!method registered?(handler)
      #   Checks whether a given handler is registered in collection
      #   @!scope instance
      #   @param handler {#as_json} a handler to be checked for presence in a collection
      #   @return [true, false]
      #   @example When a handler is registered
      #     collection = Stenotype::ContextHandlers::Collection.new
      #     collection.register(MyCustomHandler) # with handler_name = :custom_handler
      #     collection.registered?(MyCustomHandler) # true
      #
      #   @example When a handler is not registered
      #     collection = Stenotype::ContextHandlers::Collection.new
      #     collection.registered?(UnregisteredHandler) # false
      #

      alias_method :registered?, :include?
    end
  end
end
