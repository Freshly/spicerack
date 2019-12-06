# frozen_string_literal: true

module Stenotype
  module ContextHandlers
    module Rails
      #
      # ActionController handler to support fetching data out of a rails controller instance
      #
      class Controller < Stenotype::ContextHandlers::Base
        self.handler_name = :controller

        #
        # @return {Hash} a JSON representation of controller's data
        #
        def as_json(*_args)
          {
            class: controller_class.name,
            method: method,
            url: url,
            referer: referer,
            params: params.except("controller", "action"),
            ip: remote_ip,
          }
        end

        delegate :request, to: :context
        delegate :method, :url, :referer, :remote_ip, :params,
                 :controller_class, to: :request
        private :request, :method, :url, :referer, :remote_ip, :params, :controller_class
      end
    end
  end
end
