# frozen_string_literal: true

RSpec.describe Technologic::Logger do
  describe ".log" do
    subject(:log) { described_class.log(severity, event) }

    let(:severity) { Faker::Internet.domain_word.to_sym }
    let(:event) { instance_double(Technologic::Event, data: event_data) }
    let(:event_data) { Hash[*Faker::Lorem.unique.words(2 * rand(1..2))] }
    let(:data_keys) { event_data.keys }
    let(:data_values) { event_data.values }
    let(:expected_log_data) do
      data_values.each_with_index.each_with_object({}) do |(_datum, index), hash|
        hash[data_keys[index]] = "formatted_for_idx#{index}"
      end
    end

    before do
      data_values.each_with_index do |datum, index|
        allow(described_class).to receive(:format_value_for_log).with(datum).and_return("formatted_for_idx#{index}")
      end
    end

    context "when rails is not defined" do
      it "does not error" do
        expect { log }.not_to raise_error
      end
    end

    context "when rails is defined" do
      let(:rails) { double }
      let(:logger) { double }

      before do
        stub_const("Rails", rails)
        allow(rails).to receive(:logger).and_return(logger)

        data_values.each_with_index do |datum, index|
          allow(described_class).to receive(:format_value_for_log).with(datum).and_return("formatted_for_idx#{index}")
        end

        @yield = nil
        allow(logger).to receive(severity).with(no_args) { |&block| @yield = block.yield }
      end

      it "logs formatted data" do
        expect { log }.to change { @yield }.from(nil).to(expected_log_data) # rubocop:disable RSpec/InstanceVariable
      end
    end
  end

  describe ".format_value_for_log" do
    subject { described_class.format_value_for_log(value) }

    let(:formatted_value) { Faker::Lorem.word }

    shared_context "when the value is a hash" do
      let(:value) { { keys.first => object_0, keys.last => object_1 } }
      let(:keys) { Faker::Lorem.words(2).map(&:to_sym) }
      let(:object_0) { double(id: formatted_value_0) } # rubocop:disable RSpec/VerifiedDoubles
      let(:object_1) { double(to_log_string: formatted_value_1) } # rubocop:disable RSpec/VerifiedDoubles
      let(:formatted_value_0) { Faker::Lorem.unique.word }
      let(:formatted_value_1) { Faker::Lorem.unique.word }
      let(:expected_log_hash) { { keys.first => formatted_value_0, keys.last => formatted_value_1 } }
    end

    context "when value responds to #to_log_string" do
      let(:value) { double(to_log_string: formatted_value) } # rubocop:disable RSpec/VerifiedDoubles

      it { is_expected.to eq formatted_value }
    end

    context "when the value is an enumerator" do
      let(:value) { Faker::Hipster.words(3).each }

      it { is_expected.to eq value.to_s }
    end

    context "when value is a number" do
      let(:value) { 3 }

      it { is_expected.to eq value }
    end

    context "when value responds to #id" do
      let(:value) { double(id: formatted_value) } # rubocop:disable RSpec/VerifiedDoubles

      it { is_expected.to eq formatted_value }
    end

    context "when value response to #transform_values" do
      include_context "when the value is a hash"

      it { is_expected.to eq expected_log_hash }
    end

    context "when value responds to #map" do
      let(:value) { [ object_0, object_1 ] }
      let(:object_0) { double(id: formatted_value_0) } # rubocop:disable RSpec/VerifiedDoubles
      let(:object_1) { double(to_log_string: formatted_value_1) } # rubocop:disable RSpec/VerifiedDoubles
      let(:formatted_value_0) { Faker::Lorem.unique.word }
      let(:formatted_value_1) { Faker::Lorem.unique.word }

      it { is_expected.to eq [ formatted_value_0, formatted_value_1 ] }

      context "when value response to #transform_values" do
        include_context "when the value is a hash"

        it { is_expected.to eq expected_log_hash }
      end
    end

    context "without a special case" do
      let(:value) { double }

      before { allow(value).to receive(:to_s).and_return(formatted_value) }

      it { is_expected.to eq formatted_value }
    end
  end
end
