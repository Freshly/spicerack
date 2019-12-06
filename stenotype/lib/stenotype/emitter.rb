# frozen_string_literal: true

module Stenotype
  #
  # An extension for a plain Ruby class in order to track invocation of
  # instance methods.
  #
  module Emitter
    #
    # Class methods for target to be extended by
    #
    ClassMethodsExtension = Class.new(Module)
    #
    # Instance methods to be included into target class ancestors chain
    #
    InstanceMethodsExtension = Class.new(Module)

    # @!visibility private
    def self.included(klass)
      instance_mod = InstanceMethodsExtension.new
      class_mod = ClassMethodsExtension.new

      build_instance_methods(instance_mod)
      build_class_methods(class_mod)

      klass.const_set(:InstanceProxy, Module.new)
      klass.const_set(:ClassProxy, Module.new)

      klass.public_send(:include, instance_mod)
      klass.extend(class_mod)

      super
    end

    #
    # @!method emit_event(data = {}, method: caller_locations.first.label, eval_context: nil)
    #   A method injected into target class to manually track events
    #   @!scope instance
    #   @param data {Hash} Data to be sent to the targets
    #   @param method {String} An optional method name
    #   @param eval_context {Hash} A hash linking object to context handler
    #   @return {Stenotype::Event} An instance of emitted event
    #   @example Usage of emit_event
    #     class SomeRubyClass
    #       include Stenotype::Emitter
    #
    #       def some_method
    #         data = collection_data
    #         emit_event(data, eval_context: self) # Track event with given data
    #         data
    #       end
    #     end
    #

    #
    # @!method emit_event_before(*methods)
    #   A class method injected into target class to track instance methods invocation
    #   @param methods {Array<Symbol>} A list of method before which an event will be emitted
    #   @!scope class
    #   @example Usage of emit_event_before
    #     class SomeRubyClass
    #       include Stenotype::Emitter
    #       emit_event_before :some_method # Triggers an event upon calling some_method
    #
    #       def some_method
    #         # do something
    #       end
    #     end
    #

    #
    # @!method emit_klass_event_before(*class_methods)
    #   A class method injected into a target class to track class methods invocation
    #   @!scope class
    #   @param class_methods {Array<Symbol>} A list of class method before which
    #     an event will be emitted
    #   @example Usage emit_klass_event_before
    #     class SomeRubyClass
    #       include Stenotype::Emitter
    #       emit_klass_event_before :some_method # Triggers an event upon calling some_method
    #
    #       def self.some_method
    #         # do something
    #       end
    #     end
    #

    #
    # Adds an instance method: [#emit_event] to a target class
    #   where {Stenotype::Emitter} in included in
    #
    def self.build_instance_methods(instance_mod)
      instance_mod.module_eval <<-RUBY, __FILE__, __LINE__ + 1
        def emit_event(data = {}, method: caller_locations.first.label, eval_context: nil)
          Stenotype::Event.emit!(
            {
              type: "class_instance",
              **data,
            },
            options: {
              class: self.class.name,
              method: method.to_sym
            },
            eval_context: (eval_context || { klass: self })
          )
        end
      RUBY
    end

    #
    # Adds class method [#emit_klass_event_before] to every class
    #   inherited from [Object]
    #
    def self.build_class_methods(class_mod)
      class_mod.module_eval <<-RUBY, __FILE__, __LINE__ + 1
        def emit_event_before(*methods)
          proxy = const_get(:InstanceProxy)

          methods.each do |method|
            proxy.module_eval do
              define_method(method) do |*args, **rest_args, &block|
                Stenotype::Event.emit!(
                  { type: "class_instance" },
                  options: {
                    class: self.class.name,
                    method: __method__
                  },
                  eval_context: { klass: self }
                )
                super(*args, **rest_args, &block)
              end
            end
          end

          send(:prepend, proxy)
        end

        def emit_klass_event_before(*class_methods)
          proxy = const_get(:ClassProxy)

          class_methods.each do |method|
            proxy.module_eval do
              define_method(method) do |*args, **rest_args, &block|
                Stenotype::Event.emit!(
                  { type: "class" },
                  options: {
                    class: self.name,
                    method: __method__
                  },
                  eval_context: { klass: self }
                )
                super(*args, **rest_args, &block)
              end
            end

            singleton_class.send(:prepend, proxy)
          end
        end
      RUBY
    end
  end
end
