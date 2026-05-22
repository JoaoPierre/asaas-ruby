# frozen_string_literal: true

module Asaas
  module Resources
    class Subscription < Base
      def self.resource_path = "/subscriptions"

      def self.payments(id, params = {})
        path = "#{resource_path}/#{id}/payments"
        response = client.request(:get, path, params: params)
        ListObject.construct_from(response, client: client, path: path, params: params)
      end
    end
  end
end
