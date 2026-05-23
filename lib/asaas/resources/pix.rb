# frozen_string_literal: true

module Asaas
  module Resources
    class Pix
      extend HasClient

      def self.create_key(params = {})
        response = client.request(:post, "/pix/keys", params: params)
        AsaasObject.construct_from(response)
      end

      def self.list_keys(params = {})
        path = "/pix/keys"
        response = client.request(:get, path, params: params)
        ListObject.construct_from(response, client: client, path: path, params: params)
      end

      def self.delete_key(id)
        response = client.request(:delete, "/pix/keys/#{id}")
        AsaasObject.construct_from(response)
      end

      def self.create_qr_code(params = {})
        response = client.request(:post, "/pix/qrCodes", params: params)
        AsaasObject.construct_from(response)
      end

      def self.transactions(params = {})
        path = "/pix/transactions"
        response = client.request(:get, path, params: params)
        ListObject.construct_from(response, client: client, path: path, params: params)
      end

      def self.decode_qr_code(params = {})
        response = client.request(:post, "/pix/transactions/decode", params: params)
        AsaasObject.construct_from(response)
      end
    end
  end
end
