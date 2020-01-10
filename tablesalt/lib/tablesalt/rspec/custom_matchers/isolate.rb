# frozen_string_literal: true

# RSpec matcher that tests usage of `.isolate`
#
#     class Example
#       include Tablesalt::Isolation
#
#       THIS_IS_A_CONSTANT = isolate("this is a string").freeze
#       ANOTHER_CONSTANT = isolate ThisIsAClass
#     end
#
#     RSpec.describe Example do
#       describe "THIS_IS_A_CONSTANT" do
#         subject { described_class::THIS_IS_A_CONSTANT }
#
#         it { is_expected.to isolate "this is a string" }
#       end
#
#       describe "ANOTHER_CONSTANT" do
#         subject { described_class::ANOTHER_CONSTANT }
#
#         it { is_expected.to isolate ThisIsAClass }
#       end
#     end

RSpec::Matchers.define :isolate do |argument|
  match do |isolated|
    expect(isolated.frozen?).to eq argument.frozen?

    if argument.is_a?(Module)
      expect(argument).to equal isolated
    else
      expect(argument).to eq isolated
      expect(argument).not_to equal isolated
    end
  end

  description { "isolate argument #{argument}" }
  failure_message do
    "expected #{argument} to be isolated"
  end
end
