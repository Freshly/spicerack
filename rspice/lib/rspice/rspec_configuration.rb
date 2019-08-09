# frozen_string_literal: true

RSpec.configure do |config|
  config.before do
    next unless defined?(ActiveSupport::Notifications)

    allow(ActiveSupport::Notifications).to receive(:instrument).and_call_original
  end
end
