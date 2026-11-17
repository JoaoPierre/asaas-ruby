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

      def self.retrieve_transaction(id, opts = {})
        uuid = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
        unless id.is_a?(String) && id.ascii_only? && id.match?(uuid)
          raise ArgumentError, "Pix transaction ID must be a UUID"
        end

        response = client(opts).request(
          :get,
          "/pix/transactions/#{id}",
          retryable: opts.fetch(:retryable, true),
          timeout: opts[:timeout]
        )
        AsaasObject.construct_from(response)
      end

      def self.decode_qr_code(params = {}, opts = {})
        response = client(opts).request(:post, "/pix/qrCodes/decode", params: params)
        AsaasObject.construct_from(response)
      end

      def self.retrieve_key(id, opts = {})
        request_object(:get, "/pix/addressKeys/#{id}", {}, opts)
      end

      # Looks up someone else's Pix key (DICT): params { key: "..." }.
      def self.find_external_key(params = {}, opts = {})
        request_object(:get, "/pix/addressKeys/external", params, opts)
      end

      def self.token_bucket(opts = {})
        request_object(:get, "/pix/tokenBucket/addressKey", {}, opts)
      end

      def self.delete_qr_code(id, opts = {})
        request_object(:delete, "/pix/qrCodes/static/#{id}", {}, opts)
      end

      # Pays a QR Code: money leaves the account. Pass a stable opts[:idempotency_key].
      def self.pay_qr_code(params = {}, opts = {})
        request_object(:post, "/pix/qrCodes/pay", params, opts)
      end

      # Cancels a scheduled transaction.
      def self.cancel_transaction(id, opts = {})
        request_object(:post, "/pix/transactions/#{id}/cancel", {}, opts)
      end

      def self.recurrings(params = {}, opts = {})
        request_list("/pix/transactions/recurrings", params, opts)
      end

      def self.retrieve_recurring(id, opts = {})
        request_object(:get, "/pix/transactions/recurrings/#{id}", {}, opts)
      end

      def self.cancel_recurring(id, opts = {})
        request_object(:post, "/pix/transactions/recurrings/#{id}/cancel", {}, opts)
      end

      def self.recurring_items(id, params = {}, opts = {})
        request_list("/pix/transactions/recurrings/#{id}/items", params, opts)
      end

      def self.cancel_recurring_item(item_id, opts = {})
        request_object(:post, "/pix/transactions/recurrings/items/#{item_id}/cancel", {}, opts)
      end
    end
  end
end
