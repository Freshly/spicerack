# frozen_string_literal: true

module Stenotype
  module Adapters
    #
    # An adapter implementing method {#publish} to send data to STDOUT
    #
    # @example
    #   class SomeClassWithEvents
    #     def method_emitting_enent
    #       result_of_calculations = collect_some_data
    #       # This will print the data to STDOUT by default
    #       stdout_adapter.publish(result_of_calculation, additional: :data, more: :data)
    #       result_of_calculations
    #     end
    #
    #     def stdout_adapter
    #       Stenotype::Adapters::StdoutAdapter.new
    #     end
    #   end
    #
    class StdoutAdapter < Base
      #
      # @param event_data {Hash} The data to be published to STDOUT
      #
      # @example Publishing to default client (STDOUT)
      #  adapter = Stenotype::Adapters::StdoutAdapter.new
      #  adapter.publish({ event: :data }, { additional: :data })
      #
      # @example Publishing to custom client (STDERR)
      #  adapter = Stenotype::Adapters::StdoutAdapter.new(client: STDERR)
      #  adapter.publish({ event: :data }, { additional: :data })
      #
      def publish(event_data, **additional_arguments)
        client.info(**event_data, **additional_arguments)
      end

      private

      def client
        @client ||= Logger.new(STDOUT)
      end
    end
  end
end
