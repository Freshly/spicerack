# frozen_string_literal: true

# RSpec matcher that tests usage of `.prefixed_with`
#
#     class ApplicationGrodus
#       include Conjunction::Junction
#
#       prefixed_with "Grodus::"
#     end
#
#     class Grodus::Example < ApplicationGrodus; end
#
#     RSpec.describe Grodus::Example, type: :grodus do
#       it { is_expected.to have_conjunction_prefix "Grodus::" }
#     end

RSpec::Matchers.define :have_conjunction_prefix do |prefix|
  match { |subject| expect(subject.conjunction_prefix).to eq prefix }
  description { "have conjunction prefix `#{prefix}'" }
  failure_message do |subject|
    "expected #{subject} to have conjunction prefix `#{prefix}' but had `#{subject.conjunction_prefix}'"
  end
end
