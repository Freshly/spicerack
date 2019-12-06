# frozen_string_literal: true

require "stenotype/context_handlers/base"
require "stenotype/context_handlers/rails/controller"
require "stenotype/context_handlers/rails/active_job"
require "stenotype/context_handlers/klass"
require "stenotype/context_handlers/collection"

module Stenotype
  #
  # A namespace to contain various context
  # handlers implementations
  #
  module ContextHandlers
    class << self
      attr_writer :known
      #
      # @return {Array<#publish>} A list of handlers implementing [#publish]
      #
      def known
        @known ||= Stenotype::ContextHandlers::Collection.new
      end

      #
      # @param handler {#publish} A handler with implemented method [#publish]
      #
      delegate :register, to: :known
    end
  end
end
