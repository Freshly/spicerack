# frozen_string_literal: true

module Stenotype
  #
  # {Stenotype::Event} represents a triggered event
  #
  class Event
    #
    # Delegates event to instance of {Stenotype::Event}.
    #
    # @example Emit an event using class method
    #   Stenotype::Event.emit!(data, options, eval_context)
    #
    # @param data {Hash} Data to be published to the targets.
    # @param options {Hash} A hash of additional options to be tracked.
    # @param eval_context {Hash} A context having handler defined in {Stenotype::ContextHandlers}.
    # @param dispatcher {#publish} A dispatcher object responding to [#publish]
    # @return {Stenotype::Event} An instance of {Stenotype::Event}
    #
    def self.emit!(data, options: {}, eval_context: {}, dispatcher: Stenotype.config.dispatcher)
      event = new(data, options: options, eval_context: eval_context, dispatcher: dispatcher)
      event.emit!
      event
    end

    attr_reader :data, :options, :eval_context, :dispatcher

    #
    # @example Create an event
    #   event = Stenotype::Event.new(data, options, eval_context)
    # @example Create an event with custom dispatcher
    #   event = Stenotype::Event.new(data, options, eval_context, dispatcher: MyDispatcher.new)
    #
    # @param {Hash} data Data to be published to the targets.
    # @param {Hash} options A hash of additional options to be tracked.
    # @param {Hash} eval_context A context having handler defined in {Stenotype::ContextHandlers}.
    # @param dispatcher {#publish} A dispatcher object responding to [#publish].
    # @return {Stenotype::Event} An instance of event
    #
    def initialize(data, options: {}, eval_context: {}, dispatcher: Stenotype.config.dispatcher)
      @data = data
      @options = options
      @eval_context = eval_context
      @dispatcher = dispatcher.new
    end

    #
    # Emits a {Stenotype::Event}.
    #
    # @example Emit an instance of event
    #   event = Stenotype::Event.new(data, options, eval_context)
    #   event.emit! #=> Publishes the event to targets
    #
    def emit!
      dispatcher.publish(self)
    end
  end
end
