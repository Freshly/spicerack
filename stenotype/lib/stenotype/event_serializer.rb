# frozen_string_literal: true

module Stenotype
  #
  # A class used to serialize a {Stenotype::Event}
  # upon publishing it to targets
  #
  class EventSerializer
    attr_reader :event, :uuid_generator

    #
    # @example Serializing an event with default UUID generator
    #   event = Stenotype::Event.new(data, attributes, eval_context)
    #   serializer = Stenotype::EventSerializer.new(event)
    #
    # @example Serializing an event with custom UUID generator
    #   event = Stenotype::Event.new(data, attributes, eval_context)
    #   serializer = Stenotype::EventSerializer.new(event, uuid_generator: CustomUUIDGen)
    #
    # @param event {Stenotype::Event}
    # @param uuid_generator {#uuid} an object responding to [#uuid]
    #
    def initialize(event, uuid_generator: Stenotype.config.uuid_generator)
      @event = event
      @uuid_generator = uuid_generator
    end

    #
    # @example Serializing an event with default uuid generator (SecureRandom)
    #   event = Stenotype::Event.new(data, attributes, eval_context)
    #   serializer = Stenotype::EventSerializer.new(event)
    #   serializer.serialize #=> A hash with event.data, event.options,
    #                        # default_options and eval_context_options
    #
    # @example Serializing an event with custom uuid generator
    #   event = Stenotype::Event.new(data, attributes, eval_context)
    #   serializer = Stenotype::EventSerializer.new(event, uuid_generator: CustomUUIDGen)
    #   serializer.serialize #=> A hash with event.data, event.options,
    #                        # default_options and eval_context_options
    #
    # @return {Hash} A hash representation of the event and its context
    #
    def serialize
      {
        **event_data,
        **event_options,
        **default_options,
        **eval_context_options,
      }
    end

    private

    def event_data
      event.data
    end

    def event_options
      event.options
    end

    def eval_context
      event.eval_context
    end

    def eval_context_options
      context_attributes = eval_context.map do |context_name, context|
        handler = Stenotype::ContextHandlers.known.choose(handler_name: context_name)
        handler.new(context).as_json
      end
      context_attributes.reduce(:merge!) || {}
    end

    def default_options
      {
        timestamp: Time.now.utc,
        uuid: uuid_generator.uuid,
      }
    end
  end
end
