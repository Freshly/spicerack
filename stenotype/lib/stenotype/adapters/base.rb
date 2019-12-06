# frozen_string_literal: true

module Stenotype
  #
  # A namespace containing implementations of various adapters
  # for publishing events to various destinations.
  # e. g. (Google Cloud, Kafka, Stdout, other)
  #
  module Adapters
    #
    # An abstract base class for implementing adapters
    #
    # @abstract
    # @example Defining a custom adapter
    #  MyCustomAdapter < Stenotype::Adapters::Base
    #    def publish(event_data, **additional_arguments)
    #      client.publish(event_data, **additional_arguments)
    #    end
    #
    #    def client
    #      @client ||= SomeCustomClient.new(some_credential)
    #    end
    #  end
    #
    class Base
      attr_reader :client

      #
      # @return {#publish} An adapter implementing method [#publish]
      #
      def initialize(client: nil)
        @client = client
      end

      #
      # This method is expected to be implemented by subclasses
      # @abstract
      # @raise [NotImplementedError] unless implemented in a subclass
      #
      def publish(_event_data, **_additional_arguments)
        raise NotImplementedError,
              "#{self.class.name} must implement method #publish"
      end
    end
  end
end
