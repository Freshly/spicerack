# frozen_string_literal: true

module Stenotype
  #
  # A module enclosing Rails generators for gem setup
  #
  module Generators
    #
    # A class for generating a Rails initializer to setup the gem
    # upon rails application load.
    #
    class InitializerGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      #
      # Creates an initializer for rails application
      #
      def create_initializer
        template "initializer.rb.erb", File.join("config/initializers/stenotype.rb")
      end
    end
  end
end
