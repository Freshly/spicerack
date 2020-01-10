# frozen_string_literal: true

RSpec.describe Conjunction::Conjunctive, type: :conjunctive do
  include_context "with an example conjunctive"

  it { is_expected.to include_module Conjunction::Prototype }

  it { is_expected.to delegate_method(:conjugate).to(:class) }
  it { is_expected.to delegate_method(:conjugate!).to(:class) }

  shared_examples_for "conjunction_for is called" do |method_name|
    let(:junction) { Class.new }
    let(:conjunction) { Class.new }

    before do
      allow(example_conjunctive_class).to receive(:conjugate_with).with(junction, method_name).and_return(conjunction)
    end

    it { is_expected.to eq conjunction }
  end

  describe ".conjugate" do
    subject { example_conjunctive_class.conjugate(junction) }

    include_examples "conjunction_for is called", :conjunction_for
  end

  describe ".conjugate!" do
    subject { example_conjunctive_class.conjugate!(junction) }

    include_examples "conjunction_for is called", :conjunction_for!
  end

  describe ".inherited" do
    subject(:inherited_conjunctive_class) { Class.new(example_conjunctive_class) }

    let(:junction) { double(junction_key: junction_key) }
    let(:junction_key) { Faker::Internet.domain_word.to_sym }

    before { example_conjunctive_class.__send__(:conjoins, junction) }

    it "is not inherited" do
      expect(inherited_conjunctive_class.explicit_conjunctions).to eq({})
      expect(example_conjunctive_class.explicit_conjunctions).to eq(junction_key => junction)
    end
  end

  describe ".conjugate_with" do
    subject(:conjoins) { example_conjunctive_class.__send__(:conjugate_with, junction, method_name) }

    let(:junction_key) { Faker::Internet.domain_word.to_sym }
    let(:method_name) { Faker::Internet.domain_word.to_sym }
    let(:conjunction) { double }

    shared_examples_for "the expected conjunction is returned" do
      context "when respond_to?" do
        before do
          allow(junction).
            to receive(method_name).
            with(example_conjunctive_class, example_conjunctive_name).
            and_return(conjunction)
        end

        it { is_expected.to eq conjunction }
      end

      context "when not respond_to?" do
        it { is_expected.to be_nil }
      end
    end

    context "without junction_key" do
      let(:junction) { double }

      it_behaves_like "the expected conjunction is returned"
    end

    context "with junction key" do
      let(:junction) { double(junction_key: junction_key) }

      context "with explicit_conjunction" do
        let(:explicit_junction) { double(junction_key: junction_key) }

        before { example_conjunctive_class.__send__(:conjoins, explicit_junction) }

        it { is_expected.to eq explicit_junction }
      end

      context "with nexus conjunction" do
        let(:conjunctive) { example_conjunctive_class }
        let(:nexus_junction) { double(junction_key: junction_key) }

        before { Conjunction::Nexus.__send__(:couple, conjunctive, to: nexus_junction) }

        after { Conjunction::Nexus._couplings.clear }

        context "with a matching nexus_junction" do
          it { is_expected.to eq nexus_junction }
        end

        context "without a matching nexus_junction" do
          let(:conjunctive) do
            Class.new.tap { |klass| klass.include described_class }
          end

          before do
            allow(Conjunction.config).
              to receive(:nexus_use_disables_implicit_lookup).
              and_return(nexus_use_disables_implicit_lookup)
          end

          context "when nexus_use_disables_implicit_lookup" do
            let(:nexus_use_disables_implicit_lookup) { true }

            it { is_expected.to be_nil }
          end

          context "when not nexus_use_disables_implicit_lookup" do
            let(:nexus_use_disables_implicit_lookup) { false }

            before do
              allow(Conjunction.config).to receive(:disable_all_implicit_lookup).and_return(disable_all_implicit_lookup)
            end

            context "when disable_all_implicit_lookup" do
              let(:disable_all_implicit_lookup) { true }

              it { is_expected.to be_nil }
            end

            context "when not disable_all_implicit_lookup" do
              let(:disable_all_implicit_lookup) { false }

              it_behaves_like "the expected conjunction is returned"
            end
          end
        end
      end

      context "with no explicit couplings" do
        before do
          allow(Conjunction.config).
            to receive(:nexus_use_disables_implicit_lookup).
            and_return(nexus_use_disables_implicit_lookup)
        end

        context "when nexus_use_disables_implicit_lookup" do
          let(:nexus_use_disables_implicit_lookup) { true }

          it_behaves_like "the expected conjunction is returned"
        end

        context "when not nexus_use_disables_implicit_lookup" do
          let(:nexus_use_disables_implicit_lookup) { false }

          before do
            allow(Conjunction.config).to receive(:disable_all_implicit_lookup).and_return(disable_all_implicit_lookup)
          end

          context "when disable_all_implicit_lookup" do
            let(:disable_all_implicit_lookup) { true }

            it { is_expected.to be_nil }
          end

          context "when not disable_all_implicit_lookup" do
            let(:disable_all_implicit_lookup) { false }

            it_behaves_like "the expected conjunction is returned"
          end
        end
      end
    end
  end

  describe ".conjoins" do
    subject(:conjoins) { example_conjunctive_class.__send__(:conjoins, junction) }

    let(:junction) { double(junction_key: junction_key) }
    let(:junction_key) { Faker::Internet.domain_word.to_sym }

    it "changes explicit_conjunctions" do
      expect { conjoins }.
        to change { example_conjunctive_class.explicit_conjunctions }.
        from({}).
        to(junction_key => junction)
    end
  end
end
