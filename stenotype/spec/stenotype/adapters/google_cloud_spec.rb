# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::Adapters::GoogleCloud do
  describe "#publish" do
    let(:fake_topic) do
      Class.new do
        def publish(event_data, **opts); end
        def publish_async(event_data, **opts); end
      end
    end

    let(:fake_client) do
      Class.new do
        def topic(name); end
      end
    end

    let(:fake_result) do
      Class.new do
        def succeeded?; end
      end
    end

    let(:topic_double) { instance_double(fake_topic, publish: true, publish_async: true) }
    let(:fake_client_double) { instance_double(fake_client, topic: topic_double) }
    let(:event_data) { { event: :data } }
    let(:additional_arguments) { { additional: :arguments } }

    subject(:adapter) { described_class.new(client: fake_client_double) }

    context "when in async mode" do
      before { Stenotype.configure { |config| config.google_cloud.async = true } }

      context "when publishing has succeeded" do
        it "publishes the message asynchronously" do
          adapter.publish(event_data, additional_arguments)

          expect(topic_double).to have_received(:publish_async).with(event_data, additional_arguments).once
        end
      end

      context "when publish has not succeeded" do
        let(:failed_result) { instance_double(fake_result, succeeded?: false) }

        before { allow(topic_double).to receive(:publish_async).and_yield(failed_result) }

        subject(:publish) { adapter.publish(event_data, additional_arguments) }

        it "raises" do
          expect { publish }.to raise_error(Stenotype::MessageNotPublishedError)
        end
      end
    end

    context "when in sync mode" do
      before { Stenotype.configure { |config| config.google_cloud.async = false } }

      it "publishes the message synchronously" do
        adapter.publish(event_data, additional_arguments)

        expect(topic_double).to have_received(:publish).with(event_data, additional_arguments).once
      end
    end
  end
end
