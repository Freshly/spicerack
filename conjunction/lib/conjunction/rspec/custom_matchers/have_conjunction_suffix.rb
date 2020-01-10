# frozen_string_literal: true

# RSpec matcher that tests usage of `.suffixed_with`
#
#     class ApplicationLaw < Law::LawBase
#       include Conjunction::Junction
#
#       suffixed_with "Law"
#     end
#
#     RSpec.describe ApplicationLaw, type: :law do
#       it { is_expected.to have_conjunction_suffix "Law" }
#     end

RSpec::Matchers.define :have_conjunction_suffix do |suffix|
  match { |subject| expect(subject.conjunction_suffix).to eq suffix }
  description { "have conjunction suffix `#{suffix}'" }
  failure_message do |subject|
    "expected #{subject} to have conjunction suffix `#{suffix}' but had `#{subject.conjunction_prefix}'"
  end
end
