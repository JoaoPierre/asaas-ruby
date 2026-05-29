# frozen_string_literal: true

module Asaas
  module Resources
    class Subscription < Base
      def self.resource_path = "/subscriptions"

      def self.payments(id, params = {}, opts = {})
        path = "#{resource_path}/#{id}/payments"
        response = client(opts).request(:get, path, params: params)
        ListObject.construct_from(response, client: client(opts), path: path, params: params)
      end
    end
  end
end
