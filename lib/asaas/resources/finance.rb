# frozen_string_literal: true

module Asaas
  module Resources
    class Finance
      extend HasClient

      def self.balance
        response = client.request(:get, "/finance/account/balance")
        AsaasObject.construct_from(response)
      end

      def self.statistics(params = {})
        response = client.request(:get, "/finance/payment/statistics", params: params)
        AsaasObject.construct_from(response)
      end

      def self.extract(params = {})
        path = "/finance/account/extract"
        response = client.request(:get, path, params: params)
        ListObject.construct_from(response, client: client, path: path, params: params)
      end
    end
  end
end
