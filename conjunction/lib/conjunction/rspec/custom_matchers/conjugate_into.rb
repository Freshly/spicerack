# frozen_string_literal: true

# RSpec matcher that tests usage of `.conjoins`
#
#     class Foo < ApplicationRecord
#     end
#
#     class FooFleeb < ApplicationFleeb; end
#
#     RSpec.describe Foo, type: :model do
#       it { is_expected.to conjugate_into FooFleeb }
#     end

RSpec::Matchers.define :conjugate_into do |junction|
  match { |subject| expect(subject.conjugate(junction)).to eq junction }
  description { "conjugate into #{junction}" }
  failure_message { |subject| "expected #{subject} to conjugate into #{junction} but didn't" }
end
