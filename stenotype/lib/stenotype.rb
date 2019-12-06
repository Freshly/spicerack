# frozen_string_literal: true

require "securerandom"

require "spicery"
require "stenotype/version"

require "stenotype/adapters"
require "stenotype/dispatcher"
require "stenotype/configuration"
require "stenotype/context_handlers"
require "stenotype/event"
require "stenotype/event_serializer"
require "stenotype/emitter"

#
# A top level namespace for the freshly-events gem
#
module Stenotype
  # A wrapper class for Stenotype specific errors
  class Error < StandardError; end
  # This exception is being raised upon unsuccessful publishing of an event.
  class MessageNotPublishedError < Error; end
  # This exception is being raised in case no targets are
  # specified {Stenotype::Configuration}.
  class NoTargetsSpecifiedError < Error; end
  # This exception is being raised upon using a context handler which
  # has never been registered in known handlers in {Stenotype::ContextHandlers::Collection}.
  class UnknownHandlerError < Error; end

  include Spicerack::Configurable::ConfigDelegation
  delegates_to_configuration
end

Stenotype::ContextHandlers.register(Stenotype::ContextHandlers::Klass)

require "stenotype/railtie" if defined?(Rails)
