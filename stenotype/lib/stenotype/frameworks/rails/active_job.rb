# frozen_string_literal: true

require "active_support/concern"

module Stenotype
  module Frameworks
    #
    # A namespace containing extensions for Ruby on Rails components
    #
    module Rails
      #
      # An extension for ActiveJob to enable adding a hook
      # before performing an instance of [ActiveJob::Base] subclass
      #
      module ActiveJobExtension
        # @!visibility private
        def self.extended(base)
          base.const_set(:JobExt, Module.new)
          super
        end

        #
        # @example
        #   class MyJob < ApplicationJob
        #     trackable_job! # => will prepend a perform action with event recorder
        #
        #     def perform(data)
        #       # do_something
        #     end
        #   end
        #
        #
        def trackable_job!
          proxy = const_get(:JobExt)
          proxy.module_eval do
            define_method(:perform) do |*args, **rest_args, &block|
              Stenotype::Event.emit!(
                { type: "active_job" },
                { options: {},
                  eval_context: { active_job: self }},
              )
              super(*args, **rest_args, &block)
            end
          end

          # Prepend an instance of module so that
          # super() can be chained down the ancestors
          # without changing existing ActiveJob interface
          #
          public_send(:prepend, proxy)
        end
      end
    end
  end
end
