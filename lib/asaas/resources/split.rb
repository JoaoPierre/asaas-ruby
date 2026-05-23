# frozen_string_literal: true

module Asaas
  module Resources
    class Split < Base
      SPLITS_PAID = "/splits/paid"
      SPLITS_RECEIVED = "/splits/received"

      def self.paid(params = {})
        response = client.request(:get, SPLITS_PAID, params: params)
        ListObject.construct_from(response, client: client, path: SPLITS_PAID, params: params)
      end

      def self.received(params = {})
        response = client.request(:get, SPLITS_RECEIVED, params: params)
        ListObject.construct_from(response, client: client, path: SPLITS_RECEIVED, params: params)
      end

      def self.retrieve_paid(id)
        response = client.request(:get, "#{SPLITS_PAID}/#{id}")
        AsaasObject.construct_from(response)
      end

      def self.retrieve_received(id)
        response = client.request(:get, "#{SPLITS_RECEIVED}/#{id}")
        AsaasObject.construct_from(response)
      end
    end
  end
end
