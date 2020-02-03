# frozen_string_literal: true

module Directive
  module SpecHelper
    module Matchers
      module Configuration
        extend ::RSpec::Matchers::DSL
      end

      module Global
        extend ::RSpec::Matchers::DSL
      end
    end
  end
end

require_relative "matchers/configuration/define_config_option"
require_relative "matchers/global/delegate_config_to"
