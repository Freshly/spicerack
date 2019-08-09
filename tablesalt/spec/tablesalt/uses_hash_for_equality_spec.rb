# frozen_string_literal: true

RSpec.describe Tablesalt::UsesHashForEquality, type: :concern do
  subject(:example_object) { example_class.new }

  let(:example_class) do
    Class.new.tap { |klass| klass.include described_class }
  end

  it { is_expected.to alias_method :==, :eql? }

  describe "#==" do
    subject { example_object == other }

    let(:example_hash) { example_object.hash }
    let(:other) { double(hash: other_hash) }

    context "with matching other hash" do
      let(:other_hash) { example_hash }

      it { is_expected.to eq true }
    end

    context "without matching other hash" do
      let(:other_hash) { example_hash * -1 }

      it { is_expected.to eq false }
    end
  end
end
