# frozen_string_literal: true

class ExampleInputModel < Spicerack::InputModel
  argument :user
  argument :bottles_of, allow_nil: false
  argument :proof, required: true

  option :starting_bottles
  option :take_down, default: 1

  attribute :unused

  validates :take_down, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
