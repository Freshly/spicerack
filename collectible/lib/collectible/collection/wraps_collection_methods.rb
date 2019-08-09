# frozen_string_literal: true

module Collectible
  module Collection
    module WrapsCollectionMethods
      extend ActiveSupport::Concern

      PROXY_MODULE_NAME = "WrapCollectionMethods"

      included do
        collection_wrap_delegate :shift, :pop, :find, :index, :at, :[], :first, :last, :uniq, :uniq!, :sort!,
                                 :unshift, :insert, :prepend, :push, :<<, :concat, :+, :-,
                                 :any?, :empty?, :present?, :blank?, :length, :count,
                                 :each, :reverse_each, :cycle

        collection_wrap_on :collection_wrap, :select
        collection_wrap_values_on :group_by, :partition
      end

      protected

      def collection_wrap
        yield
      end

      class_methods do
        private

        def collection_wrap_delegate(*methods)
          methods.each do |method_name|
            next if method_defined?(method_name)

            define_method(method_name) do |*arguments, &block|
              collection_wrap { items.public_send(method_name, *arguments, &block) }
            end
          end
        end

        def collection_wrap_on(*methods)
          methods.each do |method_name|
            around_method(method_name, prevent_double_wrapping_for: PROXY_MODULE_NAME) do |*args, &block|
              result = super(*args, &block)

              return self if result.equal?(items)

              result.is_a?(Array) ? self.class.new(result) : result
            end
          end
        end

        def collection_wrap_values_on(*methods)
          methods.each do |method_name|
            around_method(method_name, prevent_double_wrapping_for: PROXY_MODULE_NAME) do |*args, &block|
              result = super(*args, &block)

              if result.respond_to?(:transform_values)
                result.transform_values { |collection| collection_wrap { collection } }
              elsif result.respond_to?(:map)
                result.map { |collection| collection_wrap { collection } }
              else
                collection_wrap { result }
              end
            end
          end
        end
      end
    end
  end
end
