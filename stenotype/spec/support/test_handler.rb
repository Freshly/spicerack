# frozen_string_literal: true

module Stenotype
  class TestHandler < Stenotype::ContextHandlers::Base
    self.handler_name = :klass

    def as_json(*_args)
      {}
    end
  end
end
