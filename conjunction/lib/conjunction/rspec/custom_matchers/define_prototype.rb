# frozen_string_literal: true

# RSpec matcher that tests the presence of `.prototype`
#
#     class ApplicationFleeb
#       include Conjunction::Junction
#
#       prefixed_with "Fleeb"
#     end
#
#     class GenericFleeb < ApplicationFleeb; end
#
#     RSpec.describe GenericFleeb, type: :fleeb do
#       it { is_expected.not_to define_prototype }
#     end

RSpec::Matchers.define :define_prototype do
  match { |subject| expect(subject.prototype).not_to be_nil }
  description { "define prototype" }
  failure_message { |subject| "expected #{subject} to define prototype but didn't" }
end
