# frozen_string_literal: true

RSpec.describe Tablesalt::ThreadAccessor::ThreadStore do
  subject(:instance) { described_class.new }

  # Shoulda matcher isn't working for some reason
  describe "#==" do
    subject { instance == other }

    let(:other) { double }
    let(:response) { double }

    before { allow(instance).to receive(:==).with(other).and_return(response) }

    it { is_expected.to eq response }
  end

  describe "#hash" do
    subject { instance.hash }

    it { is_expected.to eq({}) }
    it { is_expected.to equal instance.hash }

    context "when something is set in the hash" do
      let(:key) { Faker::Lorem.word }
      let(:value) { Faker::ChuckNorris.fact }

      let(:expected_hash) { { key => value } }

      before { instance[key] = value }

      it { is_expected.to eq expected_hash }
    end
  end
end
