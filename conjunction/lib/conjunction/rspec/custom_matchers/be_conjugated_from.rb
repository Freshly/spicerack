# frozen_string_literal: true

# RSpec matcher that tests usage of `.conjugate`
#
#     class Foo < ApplicationRecord
#       conjoins GenericFleeb
#     end
#
#     class GenericFleeb < ApplicationFleeb; end
#
#     RSpec.describe GenericFleeb, type: :fleeb do
#       it { is_expected.to be_conjugated_from Foo }
#     end

RSpec::Matchers.define :be_conjugated_from do |conjunctive|
  match { expect(conjunctive.conjugate(test_subject)).to eq test_subject }
  description { "be conjugated from #{conjunctive}" }
  failure_message { "expected #{test_subject} to be conjugated from #{conjunctive} but wasn't" }

  def test_subject
    subject.is_a?(Class) ? subject : subject.class
  end
end
