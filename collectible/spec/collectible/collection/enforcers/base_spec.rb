# frozen_string_literal: true

RSpec.describe Collectible::Collection::Enforcers::Base do
  let(:enforcer) { described_class.new([ 1, 2, 3 ], [ 4, 5 ]) }

  subject(:validate!) { enforcer.validate! }

  describe "#validate!" do
    it "is abstract" do
      expect { validate! }.to raise_error(NotImplementedError, %r{must implement method #publish!})
    end
  end
end
