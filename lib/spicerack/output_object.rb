# frozen_string_literal: true

require_relative "objects/status"
require_relative "objects/output"

module Spicerack
  class OutputObject < InputModel
    include Objects::Status
    include Objects::Output
  end
end
