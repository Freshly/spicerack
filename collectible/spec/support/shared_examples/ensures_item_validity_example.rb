# frozen_string_literal: true

RSpec.shared_examples_for "it ensures item validity before" do |method_name|
  context "##{method_name}" do
    context "with default validation" do
      subject(:example_collection) { collection_class.new }

      let(:collection_class) { Class.new(::Collectible::CollectionBase) }

      let(:first_item) { 42 }
      let(:another_valid_item) { 17 }
      let(:another_item) { "string" }

      context "when at least one item is present in collection" do
        before { example_collection.items.push(first_item) }

        context "when new items are valid" do
          it "adds new items to collection" do
            expect(example_collection.items).to match_array([ first_item ])
            example_collection.__send__(method_name, another_valid_item)
            expect(example_collection.items).to match_array([ first_item, another_valid_item ])
          end
        end

        context "when there is an invalid new item" do
          it "raises" do
            expect { example_collection.__send__(method_name, another_item) }.to raise_error(Collectible::Error)
          end
        end
      end

      context "when the collection is empty" do
        it "adds first item to collection" do
          expect { example_collection.__send__(method_name, another_item) }.to change { example_collection.items }.from([]).to([ another_item ])
        end
      end
    end

    context "with explicit type enforcement validation" do
      let(:string_item) { "string" }
      let(:another_string_item) { "another string" }
      let(:non_string_item) { 4242 }

      let(:collection_class) do
        Class.new(::Collectible::CollectionBase) do
          validate_elements :enforce_type, with: String
        end
      end

      subject(:example_collection) { collection_class.new }

      context "when at least one item is present in collection" do
        before { example_collection.items.push(string_item) }

        context "when type mismatch" do
          it "raises error" do
            expect { example_collection.__send__(method_name, non_string_item) }.to raise_error(Collectible::Error)
          end
        end

        context "when type match" do
          it "adds new elements to collection" do
            example_collection.__send__(method_name, another_string_item)
            expect(example_collection.items).to match_array([ string_item, another_string_item ])
          end
        end
      end
    end
  end
end
