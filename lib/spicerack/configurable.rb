# frozen_string_literal: true

require "directive"

module Spicerack
  # Deprecation support for Directive cutover.
  module Configurable
    include Directive

    def configuration_options(*args)
      _display_deprecation_notice

      super(*args)
    end

    private

    def _display_deprecation_notice
      return if @deprecation_notice_displayed

      @deprecation_notice_displayed = true

      puts "Spicerack::Configurable (used by #{self}) has been deprecated " \
           "and will be removed in Spicerack #{Gem::Version.new(VERSION).bump}. " \
           "Please use Directive instead."
    end
  end
end
