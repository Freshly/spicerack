# frozen_string_literal: true

require "active_support/concern"

module Stenotype
  #
  # A namespace containing extensions of various frameworks.
  # For example Rails components could be extended
  #
  module Frameworks
    module Rails
      #
      # An ActionController extension to be injected into classes
      # inheriting from [ActionController::Base]
      #
      module ActionControllerExtension
        extend ActiveSupport::Concern

        private

        #
        # Emits and event with given data
        # @param data {Hash} Data to be sent to targets
        #
        def _record_freshly_event(data)
          Stenotype::Event.emit!(data, options: {}, eval_context: { controller: self })
        end

        #
        # Class methods to be injected into classes
        # inherited from [ActionController::Base]
        #
        module ClassMethods
          # Adds a before_action to each action from the passed list. A before action
          # is emitting a {Stenotype::Event}. Please note that in case track_view is
          # used several times, it will keep track of the actions which emit events.
          #
          # @note Each time a new track_view is called it will find a symmetric difference
          #   of two sets: set of already tracked actions and a set passed to `track_view`.
          #
          # @example Tracking multiple actions with track_view
          #   Stenotype.configure do |config|
          #     config.enable_action_controller_extension = true
          #     config.enable_active_job_extension = true
          #   end
          #
          #   class MyController < ActionController::Base
          #     track_view :index, :show # Emits an event upon calling index and show actions,
          #                              # but does not trigger an event on create
          #
          #     def index
          #       # do_something
          #     end
          #
          #     def show
          #       # do something
          #     end
          #
          #     # Not covered by track_view
          #     def update
          #       # do something
          #     end
          #   end
          #
          # @param actions {Array<Symbol>} a list of tracked controller actions
          #
          def track_view(*actions)
            # A symmetric difference of two sets.
            # This prevents accidental duplicating of events
            delta = (_tracked_actions - Set[*actions]) | (Set[*actions] - _tracked_actions)

            return if delta.empty?

            before_action only: delta do
              _record_freshly_event(type: "view")
            end

            _tracked_actions.merge(delta)
          end

          #
          # @note This action will only define a symmetric difference of
          # the tracked actions and the ones not tracked yet.
          # @see #track_view
          #
          # @example Emitting an event before all actions in controller
          #   class UsersController < ApplicationController
          #     track_all_views # Emits an event before all actions in a controller
          #
          #     def index
          #       # do something
          #     end
          #
          #     def show
          #       # do something
          #     end
          #
          #     def create
          #       # do something
          #     end
          #   end
          #
          def track_all_views
            actions = action_methods

            # A symmetric difference of two sets.
            # This prevents accidental duplicating of events
            delta = ((_tracked_actions - actions) | (actions - _tracked_actions))

            return if delta.empty?

            before_action only: delta.to_a do
              _record_freshly_event(type: "view")
            end

            # merge is a mutating op
            _tracked_actions.merge(delta)
          end

          private

          #
          # @return {Set<Symbol>} a set of tracked actions
          #
          def _tracked_actions
            @_tracked_actions ||= Set.new
          end
        end
      end
    end
  end
end
