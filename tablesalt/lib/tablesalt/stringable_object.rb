# frozen_string_literal: true

module Tablesalt
  module StringableObject
    extend ActiveSupport::Concern

    def to_s(string_format = nil)
      case string_format
      when :pretty
        to_pretty_string
      else
        "#<%{class_name} %{attributes}>" % {
          class_name: self.class.name,
          attributes: stringable_data.map { |key, value| "#{key}: #{value}" }.join(", "),
        }
      end
    end

    private

    def stringable_data
      stringable_data_keys.each_with_object({}) do |key, result|
        result[key] = public_send(key) if respond_to?(key)
      end
    end
  end
end
