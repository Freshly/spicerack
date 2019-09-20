# frozen_string_literal: true

module Spicerack
  module Configurable
    class ConfigBuilder
      def reader
        @reader ||= Reader.new(configuration)
      end

      def configure
        yield configuration
      end

      # NOTE: options must be set up before {#configure} is called
      def option(name, *args)
        config_class.__send__(:option, name, *args)
        config_class.protect_config(name)
      end

      private

      def configuration
        @configuration ||= config_class.new
      end

      def config_class
        @config_class ||= Class.new(Config)
      end
    end
  end
end
