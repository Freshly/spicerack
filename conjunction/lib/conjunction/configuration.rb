# frozen_string_literal: true

module Conjunction
  module Configuration
    extend Spicerack::Configurable

    configuration_options do
      option :coupling_implied_by_naming_convention, default: true
    end
  end
end
