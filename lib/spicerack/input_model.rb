# frozen_string_literal: true

module Spicerack
  class InputModel < InputObject
    extend ActiveModel::Naming
    extend ActiveModel::Translation

    include ActiveModel::Conversion
    include ActiveModel::Validations
    include ActiveModel::Validations::Callbacks
  end
end
