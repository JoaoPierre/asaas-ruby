# frozen_string_literal: true

module Asaas
  module Resources
    class Customer < Base
      def self.resource_path = "/customers"

      def self.restore(id, opts = {})
        response = client(opts).request(:post, "#{resource_path}/#{id}/restore")
        AsaasObject.construct_from(response)
      end

      def self.notifications(id, params = {}, opts = {})
        path = "#{resource_path}/#{id}/notifications"
        response = client(opts).request(:get, path, params: params)
        ListObject.construct_from(response, client: client(opts), path: path, params: params)
      end
    end
  end
end
