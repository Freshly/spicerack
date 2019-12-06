# frozen_string_literal: true

module Stenotype
  #
  # {Stenotype::Dispatcher} is responsible for gluing together
  # publishing targets and data gathering.
  #
  class Dispatcher
    #
    # Publishes an event to the list of configured targets.
    #
    # @example Manually dispatching an event
    #   event = Stenotype::Event.new(data, options, eval_context)
    #   Stenotype::Dispatcher.new.publish(event)
    #
    # @param event {Stenotype::Event} An instance of event to be published.
    # @param serializer {#serialize} A class responsible for serializing the event
    # @return {Stenotype::Dispatcher} for the sake of chaining
    #
    def publish(event, serializer: Stenotype::EventSerializer)
      event_data = serializer.new(event).serialize

      targets.each do |t|
        t.publish(event_data)
      end

      self
    end

    private

    def targets
      Stenotype.config.targets
    end
  end
end
