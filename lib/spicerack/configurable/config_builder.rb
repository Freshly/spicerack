# frozen_string_literal: true

require "technologic"

module Spicerack
  module Configurable
    class ConfigBuilder
      include Technologic

      delegate :config_eval, to: :reader

      def reader
        @reader ||= Reader.new(configuration)
      end

      def configure
        mutex.synchronize do
          yield configuration
        end
      end

      # NOTE: options must be set up before {#configure} is called
      def option(*args, &block)
        config_class.__send__(:option, *args, &block)
      end

      def nested(*args, &block)
        config_class.__send__(:nested, *args, &block)
      end

      private

      attr_writer :configure_called

      def configuration
        config_class.instance
      end

      def config_class
        @config_class ||= Class.new(ConfigObject)
      end

      def mutex
        @mutex = Mutex.new
      end
    end
  end
end
