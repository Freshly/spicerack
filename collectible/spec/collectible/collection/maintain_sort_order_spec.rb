# frozen_string_literal: true

RSpec.describe Collectible::Collection::MaintainSortOrder, type: :concern do
  include_context "with an example collection"

  it { is_expected.to delegate_method(:maintain_sort_order?).to(:class) }

  describe ".maintain_sort_order" do
    subject(:maintain_sort_order) { example_collection_class.__send__(:maintain_sort_order) }

    it "sets @maintain_sort_order" do
      expect { maintain_sort_order }.
        to change { example_collection_class.instance_variable_get(:@maintain_sort_order) }.from(nil).to(true)
    end
  end

  describe ".maintain_sort_order?" do
    subject { example_collection_class.maintain_sort_order? }

    context "when @maintain_sort_order is set" do
      before { example_collection_class.instance_variable_set(:@maintain_sort_order, true) }

      it { is_expected.to eq true }
    end

    context "when @maintain_sort_order is not set" do
      it { is_expected.to eq false }
    end
  end

  describe ".inherited" do
    let(:child_off_class) { Class.new(example_collection_class) }
    let(:grandchild_off_class) { Class.new(child_off_class) }

    let(:child_on_class) do
      Class.new(example_collection_class) do
        maintain_sort_order
      end
    end
    let(:grandchild_on_class) { Class.new(child_on_class) }

    it "has expected inheritance" do
      expect(example_collection_class).not_to be_maintain_sort_order
      expect(child_off_class).not_to be_maintain_sort_order
      expect(grandchild_off_class).not_to be_maintain_sort_order

      expect(child_on_class).to be_maintain_sort_order
      expect(grandchild_on_class).to be_maintain_sort_order
    end
  end

  describe ".maintain_sorted_order_after" do
    let(:items) { unshuffled_items.shuffle }
    let(:incomparable_item) { Faker::Hipster.word }
    let(:unshuffled_items) do
      Array.new(rand(3..8)) { rand(100) }
    end

    before do
      raise ArgumentError, "items parameter must contain at least 3 items" unless items.length >= 3

      example_collection_class.__send__(:maintain_sort_order)

      allow(example_collection).to receive(:sort!).and_call_original
    end

    describe "#initialize" do
      it { is_expected.to eq example_collection_class.new(items.sort) }

      context "when an incomparable object is inserted" do
        before { items << incomparable_item }

        it "raises an ArgumentError" do
          expect { example_collection_class.new(items) }.to raise_error ArgumentError
        end
      end
    end

    describe "#push" do
      let(:added_item) { items.sample }
      let(:items_after) { items.push(added_item).sort }

      describe "returned value" do
        subject { example_collection.push(added_item) }

        it { is_expected.to eq example_collection_class.new(items_after) }
        it { is_expected.to equal example_collection }
      end

      describe "collection state" do
        subject { example_collection }

        before { example_collection.push(added_item) }

        it { is_expected.to eq example_collection_class.new(items_after) }
        it { is_expected.to equal example_collection }
        it { is_expected.to have_received(:sort!) }
      end

      context "when an incomparable object is inserted" do
        let(:added_item) { incomparable_item }

        it "raises an ArgumentError" do
          expect { example_collection.push(incomparable_item) }.to raise_error ArgumentError
        end
      end
    end

    describe "#<<" do
      let(:added_item) { items.sample }
      let(:items_after) { items.push(added_item).sort }

      describe "returned value" do
        subject { example_collection << added_item }

        it { is_expected.to eq example_collection_class.new(items_after) }
        it { is_expected.to equal example_collection }
      end

      describe "collection state" do
        subject { example_collection }

        before { example_collection << added_item }

        it { is_expected.to eq example_collection_class.new(items_after) }
        it { is_expected.to equal example_collection }
        it { is_expected.to have_received(:sort!) }
      end

      context "when an incomparable object is inserted" do
        let(:added_item) { incomparable_item }

        it "raises an ArgumentError" do
          expect { example_collection << incomparable_item }.to raise_error ArgumentError
        end
      end
    end

    describe "#concat" do
      let(:added_items) { items.sample(rand(2..items.length)) }
      let(:items_after) { items.concat(added_items).sort }

      describe "returned value" do
        subject { example_collection.concat(added_items) }

        it { is_expected.to eq example_collection_class.new(items_after) }
        it { is_expected.to equal example_collection }
      end

      describe "collection state" do
        subject { example_collection }

        before { example_collection.concat(added_items) }

        it { is_expected.to eq example_collection_class.new(items_after) }
        it { is_expected.to equal example_collection }
        it { is_expected.to have_received(:sort!) }
      end

      context "when an incomparable object is inserted" do
        before { added_items << incomparable_item }

        it "raises an ArgumentError" do
          expect { example_collection.concat(added_items) }.to raise_error ArgumentError
        end
      end
    end

    describe "#unshift" do
      subject(:unshift) { example_collection.unshift(items.sample) }

      it "raises an error" do
        expect { unshift }.to raise_error Collectible::MethodNotAllowedError, "cannot call unshift when sorted"
      end
    end

    describe "#insert" do
      subject(:insert) { example_collection.insert(items.sample, 0) }

      it "raises an error" do
        expect { insert }.to raise_error Collectible::MethodNotAllowedError, "cannot call insert when sorted"
      end
    end

    describe "#prepend" do
      subject(:prepend) { example_collection.prepend(items.sample(2)) }

      it "raises an error" do
        expect { prepend }.to raise_error Collectible::MethodNotAllowedError, "cannot call prepend when sorted"
      end
    end
  end
end
