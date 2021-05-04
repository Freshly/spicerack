# frozen_string_literal: true

require "active_model"

require_relative "input_object"

module Substance
  class InputModel < InputObject
    extend ActiveModel::Naming
    extend ActiveModel::Translation

    include ActiveModel::Conversion
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
  end
end
