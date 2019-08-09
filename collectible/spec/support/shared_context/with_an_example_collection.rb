# frozen_string_literal: true

RSpec.shared_context "with an example collection" do
  subject(:example_collection) { example_collection_class.new(*items) }

  let(:example_collection_class) { Class.new(Collectible::CollectionBase) }
  let(:items) { [] }
end
