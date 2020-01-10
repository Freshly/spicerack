# frozen_string_literal: true

# RSpec matcher that tests usage of `.conjoins`
#
#     class Foo < ApplicationRecord
#       conjoins GenericFleeb
#     end
#
#     class GenericFleeb < ApplicationFleeb; end
#
#     RSpec.describe Foo, type: :model do
#       it { is_expected.to be_conjoined_to GenericFleeb }
#     end

RSpec::Matchers.define :be_conjoined_to do |junction|
  match { |subject| expect(subject.explicit_conjunctions[junction.junction_key]).to eq junction }
  description { "be conjoined to #{junction}" }
  failure_message { |subject| "expected #{subject} to be conjoined to #{junction} but wasn't" }
end
