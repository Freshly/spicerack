# frozen_string_literal: true

RSpec.describe Collectible::Collection::Core, type: :concern do
  include_context "with an example collection"

  it { is_expected.to delegate_method(:name).to(:class).with_prefix(true) }
  it { is_expected.to delegate_method(:include?).to(:items) }
  it { is_expected.to delegate_method(:to_a).to(:items) }
  it { is_expected.to delegate_method(:to_ary).to(:items) }
  it { is_expected.to delegate_method(:select).to(:items) }
  it { is_expected.to delegate_method(:map).to(:items) }
  it { is_expected.to delegate_method(:group_by).to(:items) }
  it { is_expected.to delegate_method(:partition).to(:items) }
  it { is_expected.to delegate_method(:as_json).to(:items) }

  describe "#initialize" do
    let(:item) { rand(100) }

    context "when no arguments are passed" do
      let(:items) { [] }

      it { is_expected.to be_a described_class }
      it { is_expected.to match_array [] }
    end

    context "when an array of arguments is passed" do
      let(:items) { [[ item ]] }

      it { is_expected.to be_a described_class }
      it { is_expected.to match_array [ item ] }
    end

    context "when a single item is passed" do
      let(:items) { [ item ] }

      it { is_expected.to be_a described_class }
      it { is_expected.to match_array [ item ] }
    end

    context "when it gets some crazy BS" do
      let(:items) { [[ item, [ item, [ item, [ item ]]]]] }

      it { is_expected.to be_a described_class }
      it { is_expected.to match_array [ item, item, item, item ] }
    end

    context "when the argument is a collection" do
      let(:other_collection) { example_collection_class.new(other_items) }
      let(:other_items) { [ item, item, item, item ] }
      let(:items) { [ other_collection ] }

      it { is_expected.to eq other_collection }
      it { is_expected.to match_array other_collection }
    end
  end

  describe "#hash" do
    subject { example_collection.hash }

    it { is_expected.to eq({ class_name: example_collection_class.name, items: items }.hash) }
  end
end
