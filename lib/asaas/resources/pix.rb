# frozen_string_literal: true

module Asaas
  module Resources
    class Pix
      extend HasClient

      def self.create_key(params = {}, opts = {})
        response = client(opts).request(:post, "/pix/addressKeys", params: params)
        AsaasObject.construct_from(response)
      end

      def self.list_keys(params = {}, opts = {})
        path = "/pix/addressKeys"
        response = client(opts).request(:get, path, params: params)
        ListObject.construct_from(response, client: client(opts), path: path, params: params)
      end

      def self.delete_key(id, opts = {})
        response = client(opts).request(:delete, "/pix/addressKeys/#{id}")
        AsaasObject.construct_from(response)
      end

      def self.create_qr_code(params = {}, opts = {})
        response = client(opts).request(:post, "/pix/qrCodes/static", params: params)
        AsaasObject.construct_from(response)
      end

      def self.transactions(params = {}, opts = {})
        path = "/pix/transactions"
        response = client(opts).request(:get, path, params: params)
        ListObject.construct_from(response, client: client(opts), path: path, params: params)
      end

      def self.decode_qr_code(params = {}, opts = {})
        response = client(opts).request(:post, "/pix/qrCodes/decode", params: params)
        AsaasObject.construct_from(response)
      end
    end
  end
end
