# frozen_string_literal: true

require "spec_helper"
require "stenotype/frameworks/rails/action_controller"

RSpec.describe Stenotype::Frameworks::Rails::ActionControllerExtension do
  let(:dummy_controller) do
    Class.new(ActionController::Base) do
      def index
        head :ok
      end

      def create
        head :ok
      end

      private

      def helper
        "do something"
      end

      class << self
        def name
          "DummyController"
        end
      end
    end
  end

  let(:another_dummy_controller) do
    Class.new(ActionController::Base) do
      def index
        head :ok
      end
    end
  end

  shared_context "when a controller is given" do
    let(:dummy_request) { ActionDispatch::TestRequest.create }
    let(:dummy_response) { ActionDispatch::TestResponse.new }
    let(:dummy_controller_instance) { dummy_controller.new }
    let(:test_buffer) { [] }
    let(:test_target) { Stenotype::TestAdapter.new(test_buffer) }

    before do
      allow(dummy_controller_instance).to receive(:request).and_return(dummy_request)
      allow(dummy_request).to receive(:controller_class).and_return(dummy_controller)

      Stenotype.configure { |config| config.targets = [ test_target ] }
    end
  end

  describe ".track_view" do
    context "when called once" do
      subject(:track_view) { dummy_controller.track_view(:index) }

      it "defines a before_action" do
        expect { track_view }.to change { dummy_controller._process_action_callbacks.count }.to(1)
      end
    end

    context "when called twice" do
      subject(:track_twice) do
        dummy_controller.track_view(:index)
        dummy_controller.track_view(:index)
      end

      it "adds a callback once" do
        expect { track_twice }.to change { dummy_controller._process_action_callbacks.count }.from(0).to(1)
      end
    end
  end

  describe ".track_all_views" do
    context "when called once" do
      subject(:track_all) { dummy_controller.track_all_views }

      it "defines a before_action for all controller actions" do
        # Note that there are actually two callbacks yet ActionController lists only one
        expect { track_all }.to change { dummy_controller._process_action_callbacks.count }.to(1)
      end
    end

    context "when called twice" do
      subject(:track_all_twice) do
        dummy_controller.track_all_views
        dummy_controller.track_all_views
      end

      it "adds callbacks once" do
        expect { track_all_twice }.to change { dummy_controller._process_action_callbacks.count }.to(1)
      end
    end

    context "when an action is triggered", type: :with_frozen_time do
      include_context "when a controller is given"

      let(:expected_result) do
        {
          class: "DummyController",
          ip: "0.0.0.0",
          method: "GET",
          params: {},
          referer: nil,
          timestamp: Time.now.utc,
          type: "view",
          url: "http://test.host/",
          uuid: "abcd",
        }
      end

      before do
        dummy_controller.class_eval { track_all_views }
        dummy_controller_instance.action_name = "index"
        dummy_controller_instance.set_response!(dummy_response)
      end

      subject(:run_callbacks) { dummy_controller_instance.run_callbacks(:process_action) }

      it "emits an event" do
        expect { run_callbacks }.to change { test_buffer }.to([ expected_result ])
      end
    end
  end

  describe "#record_freshly_event", type: :with_frozen_time do
    include_context "when a controller is given"

    let(:expected_result) do
      {
        class: "DummyController",
        ip: "0.0.0.0",
        method: "GET",
        params: {},
        referer: nil,
        timestamp: Time.now.utc,
        type: "view",
        url: "http://test.host/",
        uuid: "abcd",
      }
    end

    before do
      dummy_controller.class_eval { track_view :index }
      dummy_controller_instance.action_name = "index"
      dummy_controller_instance.set_response!(dummy_response)
    end

    subject(:run_callbacks) { dummy_controller_instance.run_callbacks(:process_action) }

    it "emits an event" do
      expect { run_callbacks }.to change { test_buffer }.to([ expected_result ])
    end
  end
end
