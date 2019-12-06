# frozen_string_literal: true

require "spec_helper"
require "stenotype/frameworks/rails/active_job"

RSpec.describe Stenotype::Frameworks::Rails::ActiveJobExtension do
  let(:job_klass) do
    Class.new(ActiveJob::Base) do
      trackable_job!

      def perform(*args)
        # do something
      end

      def job_id
        "uuid"
      end

      class << self
        def name
          "DummyJob"
        end
      end
    end
  end

  let(:test_buffer) { [] }
  let(:test_target) { Stenotype::TestAdapter.new(test_buffer) }
  let(:expected_result) do
    {
      type: "active_job",
      timestamp: Time.now.utc,
      enqueued_at: Time.now.utc,
      job_id: "uuid",
      queue_name: "default",
      uuid: "abcd",
      class: "DummyJob",
    }
  end

  subject(:job_instance) { job_klass.new }

  before { Stenotype.configure { |c| c.targets = [ test_target ] } }

  describe ".trackable_job!", type: :with_frozen_time do
    it "prepends an emit event action before performing the job" do
      expect { job_instance.perform(arg: :value) }.to change { test_buffer }.to([ expected_result ])
    end
  end
end
