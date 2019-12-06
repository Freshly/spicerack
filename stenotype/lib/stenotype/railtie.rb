# frozen_string_literal: true

require "stenotype/frameworks/rails/action_controller"
require "stenotype/frameworks/rails/active_job"

module Stenotype
  #
  # A Railtie allowing to extend Rails component with
  #   Stenotype extensions for emitting event in various Rails components.
  #
  class Railtie < ::Rails::Railtie
    Stenotype.configure do |config|
      config.rails do |rails_config|
        rails_config.enable_action_controller_ext = true
        rails_config.enable_active_job_ext = true
      end
    end

    config.stenotype = Stenotype.config

    if config.stenotype.rails.enable_action_controller_ext
      ActiveSupport.on_load(:action_controller) do
        Stenotype::ContextHandlers.register Stenotype::ContextHandlers::Rails::Controller
        include Stenotype::Frameworks::Rails::ActionControllerExtension
      end
    end

    # @todo: consider using `::ActiveJob::Base.around_perform`
    #        or `::ActiveJob::Base.around_enqueue`
    if config.stenotype.rails.enable_active_job_ext
      ActiveSupport.on_load(:active_job) do
        Stenotype::ContextHandlers.register Stenotype::ContextHandlers::Rails::ActiveJob
        extend Stenotype::Frameworks::Rails::ActiveJobExtension
      end
    end
  end
end
