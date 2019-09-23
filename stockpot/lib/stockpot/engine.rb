module Stockpot
  class Engine < ::Rails::Engine
    isolate_namespace Stockpot
    config.generators.api_only = true
  end
end
