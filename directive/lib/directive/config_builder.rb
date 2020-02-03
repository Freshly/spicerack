# frozen_string_literal: true

require "technologic"
require "active_support/callbacks"

require_relative "config_builder/double_configure"

module Directive
  class ConfigBuilder
    include ActiveSupport::Callbacks
    define_callbacks :configure

    # This concern uses the configure callback, so it needs to be included after the callback is defined
    include DoubleConfigure

    delegate :config_eval, to: :reader

    def reader
      @reader ||= Reader.new(configuration)
    end

    def configure
      run_callbacks :configure do
        mutex.synchronize do
          yield configuration
        end
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
