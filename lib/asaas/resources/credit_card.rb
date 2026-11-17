# frozen_string_literal: true

module Asaas
  module Resources
    class CreditCard < Base
      def self.resource_path = "/creditCard"

      def self.tokenize(params = {}, opts = {})
        response = client(opts).request(
          :post,
          "#{resource_path}/tokenizeCreditCard",
          params: params,
          retryable: opts.fetch(:retryable, false),
          timeout: opts[:timeout]
        )
        AsaasObject.construct_from(response)
      end

      def self.pre_authorization_config(opts = {})
        request_object(:get, "#{resource_path}/preAuthorization/config", {}, opts)
      end

      def self.update_pre_authorization_config(params = {}, opts = {})
        request_object(:post, "#{resource_path}/preAuthorization/config", params, opts)
      end
    end
  end
end
