# frozen_string_literal: true

module Asaas
  module Resources
    class Finance
      extend HasClient

      def self.balance(opts = {})
        response = client(opts).request(:get, "/finance/balance", **request_options(opts))
        AsaasObject.construct_from(response)
      end

      def self.statistics(params = {}, opts = {})
        response = client(opts).request(:get, "/finance/payment/statistics", params: params, **request_options(opts))
        AsaasObject.construct_from(response)
      end

      def self.extract(params = {}, opts = {})
        path = "/financialTransactions"
        response = client(opts).request(:get, path, params: params, **request_options(opts))
        ListObject.construct_from(response, client: client(opts), path: path, params: params,
                                            request_options: request_options(opts))
      end
    end
  end
end
