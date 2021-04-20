# frozen_string_literal: true

# Options describe input which may be provided to define or override default values.
module Spicerack
  module Objects
    module Options
      extend ActiveSupport::Concern

      included do
        class_attribute :_options, instance_writer: false, default: []

        set_callback :initialize, :after do
          _options.each do |option|
            next unless _defaults.key?(option)

            public_send("#{option}=".to_sym, _defaults[option].value) if public_send(option).nil?
          end
        end
      end

      class_methods do
        def inherited(base)
          base._options = _options.dup
          super
        end

        private

        def option(option, default: nil, output: false, &block)
          _options << option
          _outputs << option if output && respond_to?(:_outputs)
          define_attribute option
          define_default option, static: default, &block
        end
      end
    end
  end
end
