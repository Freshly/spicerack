# frozen_string_literal: true

# RSpec matcher that tests usage of `.argument`
#
#     class Example < Spicerack::InputObject
#       argument :foo
#       argument :bar, allow_nil: false
#       argument :baz, required: true
#     end
#
#     RSpec.describe Example, type: :input_object do
#       subject { described_class.new(**input) }
#
#       let(:input) { {} }
#
#       it { is_expected.to define_argument :foo }
#       it { is_expected.to define_argument :bar, allow_nil: false }
#       it { is_expected.to define_argument :baz, required: true }
#     end

RSpec::Matchers.define :define_argument do |argument, allow_nil: true, required: false|
  match { |instance| expect(instance._arguments[argument]).to eq(allow_nil: allow_nil, required: required) }
  description { "define argument #{argument}" }
  failure_message do
    "expected #{described_class} to define argument #{argument} #{prohibit_nil_description unless allow_nil}"
  end

  def prohibit_nil_description
    "and prohibit a nil value"
  end
end
