# frozen_string_literal: true

require_relative "spec_helper/matchers"
require_relative "spec_helper/dsl"

RSpec.configure do |config|
  config.include(Directive::SpecHelper::Matchers::Global)
  config.include(Directive::SpecHelper::Matchers::Configuration, type: :configuration)
  config.include(Directive::SpecHelper::DSL, type: :configuration)
end
