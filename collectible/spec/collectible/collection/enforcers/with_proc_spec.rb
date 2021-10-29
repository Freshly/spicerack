# frozen_string_literal: true

RSpec.describe Collectible::Collection::Enforcers::WithProc do
  let(:enforcer) do
    described_class.new(
      existing_items,
      new_items,
      validate_with: validation_proc,
    )
  end

  describe "#validate!" do
    subject(:validate!) { enforcer.validate! }

    context "when new items are valid" do
      let(:existing_items) { [ 42, 17, 137 ] }
      let(:new_items) { [ 3.14, 2.71 ] }

      let(:validation_proc) { ->(_) { true } }

      it "does not raise" do
        expect(validate!).to be_truthy
      end
    end

    context "when at least one item is invalid" do
      let(:existing_items) { [ 42, 17, 137 ] }
      let(:new_items) { [ "invalid items sample" ] }

      let(:validation_proc) { ->(_) { false } }

      it "raises ItemNotAllowed" do
        expect { validate! }.to raise_error(Collectible::ItemNotAllowedError)
      end
    end
  end
end
