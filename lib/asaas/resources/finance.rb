# frozen_string_literal: true

module Asaas
  module Resources
    class Finance
      extend HasClient

      def self.balance(opts = {})
        response = client(opts).request(:get, "/finance/balance")
        AsaasObject.construct_from(response)
      end

      def self.statistics(params = {}, opts = {})
        response = client(opts).request(:get, "/finance/payment/statistics", params: params)
        AsaasObject.construct_from(response)
      end

      def self.extract(params = {}, opts = {})
        path = "/financialTransactions"
        response = client(opts).request(:get, path, params: params)
        ListObject.construct_from(response, client: client(opts), path: path, params: params)
      end
    end
  end
end
