# frozen_string_literal: true

module Spicerack
  module Configurable
    class Evaluator
      # @param path [Array<Symbol, String>] A message path for the desired config
      # @param configuration [Spicerack::Configurable::Reader]
      def initialize(path, configuration)
        @path = path
        @configuration = configuration
      end

      def read
        path.inject(configuration, &:public_send)
      end

      private

      attr_reader :path, :configuration
    end
  end
end