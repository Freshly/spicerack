# frozen_string_literal: true

# RSpec matcher that tests usage of `.suffixed_with`
#
#     class ApplicationDingleBop
#       include Conjunction::Junction
#
#       suffixed_with "DingleBop"
#     end
#
#     RSpec.describe ApplicationDingleBop, type: :dingle_bop do
#       it { is_expected.to have_junction_key :dingle_bop }
#     end

RSpec::Matchers.define :have_junction_key do |key|
  match { |subject| expect(subject.junction_key).to eq key }
  description { "have junction key `#{key}'" }
  failure_message do |subject|
    "expected #{subject} to have junction key `#{key}' but had `#{subject.junction_key}'"
  end
end
