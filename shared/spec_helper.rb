# frozen_string_literal: true

require "bundler/setup"
require "simplecov"
require "pry"

require "shoulda-matchers"

require "active_record"
require "will_paginate"
require "will_paginate/active_record"

require_relative "../lib/spicerack/version"
require_relative "../spicery/lib/spicery/spec_helper"

require_relative "shared_examples/a_versioned_spicerack_gem"

SimpleCov.start do
  add_filter "/spec/"
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

RSpec.configure do |config|
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) { Redis.new.flushdb if defined?(Redis) }
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
  end
end
