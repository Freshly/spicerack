# frozen_string_literal: true

RSpec.describe Conjunction::Nexus, type: :nexus do
  include_context "with an example junction"
  include_context "with an example conjunctive"

  subject(:nexus) { described_class }

  let(:conjunctive) { Class.new(example_conjunctive_class) }
  let(:junction) { Class.new(example_junction_class) }

  it { is_expected.to include_module Singleton }

  after { nexus._couplings.clear }

  describe ".couple" do
    subject(:couple) { described_class.__send__(:couple, conjunctive, to: junction) }

    context "with invalid conjunctive" do
      let(:conjunctive) { double }

      it "raises" do
        expect { couple }.to raise_error TypeError, "#{conjunctive} is not a valid conjunctive"
      end
    end

    context "with invalid junction" do
      let(:junction) { double }

      it "raises" do
        expect { couple }.to raise_error TypeError, "#{junction} is not a valid junction"
      end
    end

    context "when unidirectional" do
      it "changes _couplings" do
        expect { couple }.
          to change { nexus._couplings }.to(junction.junction_key => { conjunctive => junction })
      end
    end

    context "when bidirectional" do
      subject(:couple) { described_class.__send__(:couple, conjunctive, to: junction, bidirectional: true) }

      context "without conjunctive junction" do
        it "raises" do
          expect { couple }.to raise_error TypeError, "#{conjunctive} is not a valid junction"
        end
      end

      context "with conjunctive junction" do
        let(:conjunctive_prefix) { Faker::Internet.domain_word.capitalize }

        let(:conjunctive) do
          Class.new(example_conjunctive_class).tap do |klass|
            klass.include Conjunction::Junction
            klass.__send__(:prefixed_with, conjunctive_prefix)
          end
        end

        it "changes _couplings" do
          expect { couple }.
            to change { nexus._couplings }.
            to(
              junction.junction_key => { conjunctive => junction },
              conjunctive.junction_key => { junction => conjunctive },
            )
        end
      end
    end
  end

  describe ".conjugate" do
    subject(:conjugate) { described_class.conjugate(conjunctive, junction: junction_class) }

    let(:junction_class) { example_junction_class }

    context "with invalid junction" do
      let(:junction_class) { double }

      it { is_expected.to be_nil }
    end

    context "without coupling" do
      it { is_expected.to be_nil }
    end

    context "with coupling" do
      before { described_class.__send__(:couple, conjunctive, to: junction) }

      it { is_expected.to eq junction }
    end
  end
end
