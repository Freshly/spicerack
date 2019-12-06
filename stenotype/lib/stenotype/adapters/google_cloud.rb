# frozen_string_literal: true

require "google/cloud/pubsub"

module Stenotype
  module Adapters
    #
    # An adapter implementing method {#publish} to send data to Google Cloud PubSub
    #
    # @example A general usage within some method in the class
    #   class EventEmittingClass
    #     def method_emitting_enent
    #       result_of_calculations = collect_some_data
    #       gc_adapter.publish(result_of_calculation, additional: :data, more: :data)
    #       result_of_calculations
    #     end
    #
    #     def gc_adapter
    #       Stenotype::Adapters::GoogleCloud.new
    #     end
    #   end
    #
    # @example Overriding a client
    #   class EventEmittingClass
    #     def method_emitting_enent
    #       result_of_calculations = collect_some_data
    #       gc_adapter.publish(result_of_calculation, additional: :data, more: :data)
    #       result_of_calculations
    #     end
    #
    #     def gc_adapter
    #       Stenotype::Adapters::GoogleCloud.new(client: CustomGcClient.new)
    #     end
    #   end
    #
    class GoogleCloud < Base
      #
      # @param event_data {Hash} The data to be published to Google Cloud
      # @raise {Stenotype::MessageNotPublishedError} unless message is published
      #
      # @example With default client
      #   google_cloud_adapter = Stenotype::Adapters::GoogleCloud.new
      #   # publishes to default client
      #   google_cloud_adapter.publish({ event: :data }, { additional: :data })
      #
      # @example With client override
      #   google_cloud_adapter = Stenotype::Adapters::GoogleCloud.new(CustomGCClient.new)
      #   # publishes to default CustomGCClient
      #   google_cloud_adapter.publish({ event: :data }, { additional: :data })
      #
      def publish(event_data, **additional_arguments)
        if config.async
          publish_async(event_data, **additional_arguments)
        else
          publish_sync(event_data, **additional_arguments)
        end
      end

      private

      def publish_sync(event_data, **additional_arguments)
        topic.publish(event_data, additional_arguments)
      end

      def publish_async(event_data, **additional_arguments)
        topic.publish_async(event_data, additional_arguments) do |result|
          raise Stenotype::MessageNotPublishedError unless result.succeeded?
        end
      end

      # :nocov:
      def client
        @client ||= Google::Cloud::PubSub.new(project_id: config.project_id, credentials: config.credentials)
      end

      # Use memoization, otherwise a new topic will be created
      # every time. And a new async_publisher will be created.
      # :nocov:
      def topic
        @topic ||= client.topic config.topic
      end

      def config
        Stenotype.config.google_cloud
      end
    end
  end
end
