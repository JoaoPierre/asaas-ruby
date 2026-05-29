# frozen_string_literal: true

module Asaas
  module Resources
    class Subaccount < Base
      def self.resource_path = "/accounts"

      def self.create_api_key(id, opts = {})
        response = client(opts).request(:post, "#{resource_path}/#{id}/apiKeys")
        AsaasObject.construct_from(response)
      end

      def self.api_keys(id, params = {}, opts = {})
        path = "#{resource_path}/#{id}/apiKeys"
        response = client(opts).request(:get, path, params: params)
        ListObject.construct_from(response, client: client(opts), path: path, params: params)
      end
    end
  end
end
