# frozen_string_literal: true

require "rails/generators"
require "rails/generators/testing/behaviour"
require "rails/generators/testing/setup_and_teardown"
require "rails/generators/testing/assertions"
require "fileutils"

module Stenotype
  module GeneratorHelper
    extend ActiveSupport::Concern
    include ::Rails::Generators::Testing::Behaviour
    include ::Rails::Generators::Testing::SetupAndTeardown
    include ::Rails::Generators::Testing::Assertions
    include FileUtils

    def file(relative)
      File.expand_path(relative, destination_root)
    end

    module Macros
      def set_default_destination
        destination File.expand_path("../../tmp", __dir__)
      end

      def setup_default_destination
        set_default_destination
        self.generator_class = described_class
        before { prepare_destination }

        after { rm_rf File.expand_path("tmp/config") }
      end
    end

    def self.included(klass)
      klass.extend(Macros)
    end
  end
end
