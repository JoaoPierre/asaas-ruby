# frozen_string_literal: true

module Asaas
  module Resources
    class Subaccount < Base
      def self.resource_path = "/accounts"

      def self.create_access_token(id, params = {}, opts = {})
        request_object(:post, "#{resource_path}/#{id}/accessTokens", params, opts)
      end

      def self.access_tokens(id, params = {}, opts = {})
        request_list("#{resource_path}/#{id}/accessTokens", params, opts)
      end

      def self.update_access_token(id, access_token_id, params = {}, opts = {})
        request_object(:put, "#{resource_path}/#{id}/accessTokens/#{access_token_id}", params, opts)
      end

      def self.delete_access_token(id, access_token_id, opts = {})
        request_object(:delete, "#{resource_path}/#{id}/accessTokens/#{access_token_id}", {}, opts)
      end

      def self.create_api_key(id, opts = {}) = create_access_token(id, {}, opts)
      def self.api_keys(id, params = {}, opts = {}) = access_tokens(id, params, opts)

      # Non-BaaS subaccounts only.
      def self.resend_activation_link(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/resendActivationLink", {}, opts)
      end
    end
  end
end
