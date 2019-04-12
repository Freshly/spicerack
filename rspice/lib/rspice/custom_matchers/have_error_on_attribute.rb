# frozen_string_literal: true

# RSpec matcher that tests usages of [ActiveModel::Errors](https://api.rubyonrails.org/classes/ActiveModel/Errors.html)
#
#     class Klass < ApplicationRecord
#       validate_uniqueness_of :attribute
#     end
#
#     RSpec.describe Klass, type: :model do
#       subject(:klass) { model.new(attribute: attribute) }
#
#       let(:attribute) { "attribute" }
#
#       before do
#         model.create(attribute: attribute)
#         klass.validate
#       end
#
#       it { is_expected.to have_error_on_attribute(:attribute).with_detail_key(:taken) }
#     end

RSpec::Matchers.define :have_error_on_attribute do |attribute|
  match do |record|
    raise ArgumentError, "have_error_on_attribute matcher requires a detail_key" if @detail_key.blank?

    errors = (record.errors.details[attribute.to_sym] || []).pluck(:error)

    expect(errors).to include(@detail_key)
  end

  chain :with_detail_key do |detail_key|
    @detail_key = detail_key
  end

  description do
    "have_error_on_attribute #{attribute} with_detail_key #{@detail_key.inspect}"
  end

  failure_message do |record|
    "expected #{record} to have error on attribute #{attribute} with detail key #{@detail_key.inspect}"
  end

  failure_message_when_negated do |record|
    "expected #{record} not to have error on attribute #{attribute} with detail key #{@detail_key.inspect}"
  end
end