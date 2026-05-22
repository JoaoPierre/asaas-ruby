# frozen_string_literal: true

module Asaas
  module Resources
    class Customer < Base
      def self.resource_path = "/customers"

      def self.restore(id)
        response = client.request(:post, "#{resource_path}/#{id}/restore")
        AsaasObject.construct_from(response)
      end

      def self.notifications(id, params = {})
        path = "#{resource_path}/#{id}/notifications"
        response = client.request(:get, path, params: params)
        ListObject.construct_from(response, client: client, path: path, params: params)
      end
    end
  end
end
