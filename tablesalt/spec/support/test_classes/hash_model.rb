# frozen_string_literal: true

class ExampleHashModelBase
  include Tablesalt::HashModel

  class << self
    def for(hash)
      new.tap { |model| model.hash = hash }
    end
  end
end

class TaskHashModel < ExampleHashModelBase
  field :started_at, :datetime
  field :finished_at, :datetime
end

class ProcessorHashModel < TaskHashModel
  field :count, :integer, default: 42
  field :rate, :float, default: 3.14
end