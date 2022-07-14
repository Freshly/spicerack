# frozen_string_literal: true

require "active_support/concern"

module Tablesalt
  module ClassPass
    extend ActiveSupport::Concern

    included do
      class_attribute :_class_pass_methods, instance_writer: false, default: []
    end

    class_methods do
      def inherited(base)
        base._class_pass_methods = _class_pass_methods.dup
        super
      end

      private

      def class_pass_method(*methods, to: nil)
        methods.each do |method|
          next if _class_pass_methods.include?(method)

          _class_pass_methods << method

          define_singleton_method method do |*args, **attrs|
            # TODO: replace with ... when 2.6 support is removed
            if RUBY_VERSION < "2.7.0" && attrs.empty?
              new(*args).public_send(to || method)
            else
              new(*args, **attrs).public_send(to || method)
            end
          end
        end
      end
    end
  end
end
