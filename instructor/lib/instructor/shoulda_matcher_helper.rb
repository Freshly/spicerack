# frozen_string_literal: true

if defined?(Shoulda::Matchers::ActiveModel)
  RSpec.configure do |config|
    config.include(Shoulda::Matchers::ActiveModel, type: :instructor)
  end
end
