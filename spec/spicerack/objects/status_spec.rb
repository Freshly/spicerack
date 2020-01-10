# frozen_string_literal: true

RSpec.describe Spicerack::Objects::Status, type: :concern do
  include_context "with an example output object"

  describe "#validated?" do
    subject { example_output_object.validated? }

    before { stub_const(Faker::Internet.domain_word.capitalize, example_output_object_class) }

    it { is_expected.to be false }

    context "when callbacks run" do
      subject { -> { example_output_object.valid? } }

      context "with errors" do
        before do
          example_output_object_class.__send__(:define_attribute, :name)
          example_output_object_class.validates :name, presence: true
        end

        it { is_expected.not_to change { example_output_object.validated? }.from(false) }
      end

      context "without errors" do
        it { is_expected.to change { example_output_object.validated? }.from(false).to(true) }
      end
    end
  end
end
