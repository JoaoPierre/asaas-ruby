# frozen_string_literal: true

module Asaas
  module Resources
    class Split
      extend HasClient

      SPLITS_PAID = "/payments/splits/paid"
      SPLITS_RECEIVED = "/payments/splits/received"

      def self.paid(params = {}, opts = {})
        response = client(opts).request(:get, SPLITS_PAID, params: params)
        ListObject.construct_from(response, client: client(opts), path: SPLITS_PAID, params: params)
      end

      def self.received(params = {}, opts = {})
        response = client(opts).request(:get, SPLITS_RECEIVED, params: params)
        ListObject.construct_from(response, client: client(opts), path: SPLITS_RECEIVED, params: params)
      end

      def self.retrieve_paid(id, opts = {})
        response = client(opts).request(:get, "#{SPLITS_PAID}/#{id}")
        AsaasObject.construct_from(response)
      end

      def self.retrieve_received(id, opts = {})
        response = client(opts).request(:get, "#{SPLITS_RECEIVED}/#{id}")
        AsaasObject.construct_from(response)
      end
    end
  end
end
