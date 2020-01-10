# frozen_string_literal: true

RSpec.describe Conjunction::NamingConvention, type: :concern do
  include_context "with an example naming convention"

  describe ".conjunction_prefix" do
    subject { example_naming_convention_class.conjunction_prefix }

    let(:prefix) { nil }

    it { is_expected.to be_nil }
  end

  describe ".conjunction_suffix" do
    subject { example_naming_convention_class.conjunction_suffix }

    let(:suffix) { nil }

    it { is_expected.to be_nil }
  end

  describe ".conjunction_prefix?" do
    subject { example_naming_convention_class }

    context "with conjunction_prefix" do
      it { is_expected.to be_conjunction_prefix }
    end

    context "without conjunction_prefix" do
      let(:prefix) { nil }

      it { is_expected.not_to be_conjunction_prefix }
    end
  end

  describe ".conjunction_suffix?" do
    subject { example_naming_convention_class }

    context "with conjunction_suffix" do
      it { is_expected.to be_conjunction_suffix }
    end

    context "without conjunction_suffix" do
      let(:suffix) { nil }

      it { is_expected.not_to be_conjunction_suffix }
    end
  end

  describe ".conjunctive?" do
    subject { example_naming_convention_class }

    context "with neither" do
      let(:prefix) { nil }
      let(:suffix) { nil }

      it { is_expected.not_to be_conjunctive }
    end

    context "with only prefix" do
      let(:suffix) { nil }

      it { is_expected.to be_conjunctive }
    end

    context "with only suffix" do
      let(:prefix) { nil }

      it { is_expected.to be_conjunctive }
    end

    context "with both" do
      it { is_expected.to be_conjunctive }
    end
  end

  describe ".inherited" do
    subject(:inherited_naming_convention_class) { Class.new(example_naming_convention_class) }

    it "is inherited" do
      expect(example_naming_convention_class.conjunction_prefix).to eq prefix
      expect(example_naming_convention_class.conjunction_suffix).to eq suffix

      expect(inherited_naming_convention_class.conjunction_prefix).to eq prefix
      expect(inherited_naming_convention_class.conjunction_suffix).to eq suffix
    end
  end

  describe ".prefixed_with" do
    subject(:prefixed_with) { example_naming_convention_class.__send__(:prefixed_with, prefix) }

    context "when string" do
      let(:example_naming_convention_class) do
        Class.new.tap { |klass| klass.include described_class }
      end

      it "changes conjunction_prefix" do
        expect { prefixed_with }.to change { example_naming_convention_class.conjunction_prefix }.from(nil).to(prefix)
      end
    end

    context "when nil" do
      let(:prefix) { nil }
      let(:original) { Faker::Lorem.word }

      before { example_naming_convention_class.__send__(:prefixed_with, original) }

      it "changes conjunction_prefix" do
        expect { prefixed_with }.to change { example_naming_convention_class.conjunction_prefix }.from(original).to(nil)
      end
    end

    context "when other" do
      let(:prefix) { double }

      it "raises" do
        expect { prefixed_with }.to raise_error TypeError, "prefix must be a string"
      end
    end
  end

  describe ".suffixed_with" do
    subject(:suffixed_with) { example_naming_convention_class.__send__(:suffixed_with, suffix) }

    context "when string" do
      let(:example_naming_convention_class) do
        Class.new.tap { |klass| klass.include described_class }
      end

      it "changes conjunction_prefix" do
        expect { suffixed_with }.to change { example_naming_convention_class.conjunction_suffix }.from(nil).to(suffix)
      end
    end

    context "when nil" do
      let(:suffix) { nil }
      let(:original) { Faker::Lorem.word }

      before { example_naming_convention_class.__send__(:suffixed_with, original) }

      it "changes conjunction_prefix" do
        expect { suffixed_with }.to change { example_naming_convention_class.conjunction_suffix }.from(original).to(nil)
      end
    end

    context "when other" do
      let(:suffix) { double }

      it "raises" do
        expect { suffixed_with }.to raise_error TypeError, "suffix must be a string"
      end
    end
  end
end
