# frozen_string_literal: true

# RSpec matcher that tests the value of `.prototype`
#
#     class ApplicationFleeb < ActiveRecord::Base
#       include Conjunction::Junction
#
#       prefixed_with "Fleeb"
#     end
#
#     class FooFleeb < ApplicationFleeb; end
#
#     RSpec.describe FooFleeb, type: :fleeb do
#       it { is_expected.to have_prototype Foo }
#     end

RSpec::Matchers.define :have_prototype do |prototype|
  match { |subject| expect(subject.prototype).to eq prototype }
  description { "have prototype name `#{prototype}'" }
  failure_message { |subject| "expected #{subject} to have prototype `#{prototype}' but had `#{subject.prototype}'" }
end
