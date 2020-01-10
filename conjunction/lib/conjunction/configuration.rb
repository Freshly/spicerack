# frozen_string_literal: true

module Conjunction
  module Configuration
    extend Spicerack::Configurable

    configuration_options do
      option :nexus_use_disables_implicit_lookup, default: false
      option :disable_all_implicit_lookup, default: false
    end
  end
end
