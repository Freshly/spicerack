# frozen_string_literal: true

RSpec.configure do |config|
  config.after(:each) do
    Thread.current[Tablesalt::ThreadAccessor::STORE_THREAD_KEY] = nil
  end
end
