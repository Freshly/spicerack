# frozen_string_literal: true

require_relative "input_model"
require_relative "objects/status"
require_relative "objects/output"

module Substance
  class OutputObject < InputModel
    include Objects::Status
    include Objects::Output
  end
end
