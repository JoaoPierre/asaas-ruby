# frozen_string_literal: true

module Asaas
  module Resources
    class Subaccount < Base
      def self.resource_path = "/subaccounts"

      def self.create_api_key(id)
        response = client.request(:post, "#{resource_path}/#{id}/apiKeys")
        AsaasObject.construct_from(response)
      end

      def self.api_keys(id, params = {})
        path = "#{resource_path}/#{id}/apiKeys"
        response = client.request(:get, path, params: params)
        ListObject.construct_from(response, client: client, path: path, params: params)
      end
    end
  end
end
