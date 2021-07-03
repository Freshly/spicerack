# frozen_string_literal: true

RSpec.configure do |config|
  config.around(:each) do |example|
    Tablesalt::ThreadAccessor.with_isolated_thread_context(&example)
  end
end
