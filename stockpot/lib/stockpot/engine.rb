# frozen_string_literal: true

module Stockpot
  class Engine < ::Rails::Engine
    isolate_namespace Stockpot
    config.generators.api_only = true

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
