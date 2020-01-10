# frozen_string_literal: true

RSpec.describe Conjunction::Junction, type: :junction do
  include_context "with an example junction"

  it { is_expected.to include_module Conjunction::Conjunctive }
  it { is_expected.to include_module Conjunction::NamingConvention }

  it { is_expected.to delegate_method(:conjunction_for!).to(:class) }
  it { is_expected.to delegate_method(:conjunction_for).to(:class) }
  it { is_expected.to delegate_method(:conjunction_name_for).to(:class) }

  describe ".junction_key" do
    subject { example_junction_class.junction_key }

    context "with neither" do
      let(:prefix) { nil }
      let(:suffix) { nil }

      it { is_expected.to be_nil }
    end

    context "without suffix" do
      let(:suffix) { nil }

      it { is_expected.to eq prefix.downcase.to_sym }
    end

    context "without prefix" do
      let(:prefix) { nil }

      it { is_expected.to eq suffix.downcase.to_sym }
    end

    context "with both" do
      it { is_expected.to eq "#{prefix.downcase}_#{suffix.downcase}".to_sym }
    end
  end

  describe ".prototype_name" do
    subject { example_junction_class.prototype_name }

    context "without configuration" do
      let(:prefix) { nil }
      let(:suffix) { nil }

      it { is_expected.to be_nil }
    end

    context "without prefix" do
      let(:prefix) { nil }

      it { is_expected.to eq prototype_name }
    end

    context "without suffix" do
      let(:suffix) { nil }

      it { is_expected.to eq prototype_name }
    end

    context "with both prefix and suffix" do
      it { is_expected.to eq prototype_name }
    end
  end

  describe ".conjunction_name_for" do
    subject(:conjunction_for) do
      example_junction_class.__send__(:conjunction_name_for, other_prototype, prototype_name)
    end

    let(:prototype_name) { Faker::Internet.domain_word.capitalize }

    shared_examples_for "a valid prototype" do
      let(:other_prototype) { double(prototype_name: prototype_name) }

      context "with neither" do
        let(:prefix) { nil }
        let(:suffix) { nil }

        it { is_expected.to be_nil }
      end

      context "without prefix" do
        let(:prefix) { nil }

        it { is_expected.to eq "#{prototype_name}#{suffix}" }
      end

      context "without suffix" do
        let(:suffix) { nil }

        it { is_expected.to eq "#{prefix}#{prototype_name}" }
      end

      context "with both" do
        it { is_expected.to eq "#{prefix}#{prototype_name}#{suffix}" }
      end
    end

    context "when both are nil" do
      let(:other_prototype) { nil }
      let(:prototype_name) { nil }

      it { is_expected.to be_nil }
    end

    context "when other_prototype is nil" do
      let(:other_prototype) { nil }

      it_behaves_like "a valid prototype"
    end

    context "when valid" do
      it_behaves_like "a valid prototype"
    end
  end

  describe ".conjunction_for" do
    subject(:conjunction_for) { example_junction_class.conjunction_for(other_prototype, prototype_name) }

    let(:prototype_name) { Faker::Internet.domain_word.capitalize }
    let(:other_prototype) { double }

    before do
      allow(example_junction_class).
        to receive(:conjunction_name_for).
        with(other_prototype, prototype_name).
        and_return(conjunction_name)
    end

    context "when nil" do
      let(:conjunction_name) { nil }

      it { is_expected.to be_nil }
    end

    context "when present" do
      let(:conjunction_name) { Faker::Internet.domain_word.capitalize }

      context "with class" do
        let(:conjunction_class) { Class.new }

        before { stub_const(conjunction_name, conjunction_class) }

        it { is_expected.to eq conjunction_class }
      end

      context "without class" do
        it { is_expected.to be_nil }
      end
    end
  end

  describe ".conjunction_for!" do
    subject(:conjunction_for!) { example_junction_class.conjunction_for!(other_prototype, other_prototype_name) }

    let(:other_prototype) { double }
    let(:other_prototype_name) { Faker::Internet.domain_word.capitalize }

    before do
      allow(example_junction_class).
        to receive(:conjunction_for).
        with(other_prototype, other_prototype_name).
        and_return(conjunction_for)
    end

    context "when nil" do
      let(:conjunction_for) { nil }

      it "raises" do
        expect { conjunction_for! }.
          to raise_error Conjunction::DisjointedError, "#{other_prototype} #{example_junction_name} unknown"
      end
    end

    context "when present" do
      let(:conjunction_for) { double }

      it { is_expected.to eq conjunction_for }
    end
  end
end
