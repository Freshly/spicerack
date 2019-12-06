# frozen_string_literal: true

require "stenotype/adapters/base"

module Stenotype
  class TestAdapter < Stenotype::Adapters::Base
    attr_writer :buffer

    def initialize(buffer = [])
      @buffer = buffer
      super()
    end

    def publish(event_data)
      buffer << event_data
    end

    def buffer
      @buffer || raise(
        NotImplementedError,
        "Please specify a buffer for test adapter",
      )
    end
  end
end
