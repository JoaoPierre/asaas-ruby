# frozen_string_literal: true

module Asaas
  module Resources
    # Escrow account: holds a payment's money until it is finished.
    # A payment's own escrow is Payment.escrow(id).
    class Escrow
      extend HasClient

      def self.default_config(opts = {})
        request_object(:get, "/accounts/escrow", {}, opts)
      end

      def self.save_default_config(params = {}, opts = {})
        request_object(:post, "/accounts/escrow", params, opts)
      end

      def self.config(account_id, opts = {})
        request_object(:get, "/accounts/#{account_id}/escrow", {}, opts)
      end

      def self.save_config(account_id, params = {}, opts = {})
        request_object(:post, "/accounts/#{account_id}/escrow", params, opts)
      end

      # Releases the payment's money before the escrow expires.
      def self.finish(id, opts = {})
        request_object(:post, "/escrow/#{id}/finish", {}, opts)
      end
    end
  end
end
