# frozen_string_literal: true

RSpec.describe ExampleInputModel, type: :input_model do
  subject(:input_model) { described_class.new(user: :a, bottles_of: :b, proof: :c) }

  it { is_expected.to define_argument :user }
  it { is_expected.to define_argument :bottles_of, allow_nil: false }
  it { is_expected.to define_argument :proof, required: true }
  it { is_expected.to define_option :starting_bottles }
  it { is_expected.to define_option :take_down, default: 1 }
  it { is_expected.to define_attribute :unused }
  it { is_expected.to validate_numericality_of(:take_down).is_greater_than_or_equal_to(0).only_integer }

  describe "#to_s" do
    subject { input_model.to_s }

    it { is_expected.to eq "#<ExampleInputModel user=a bottles_of=b proof=c starting_bottles= take_down=1 unused=>" }
  end
end
