# frozen_string_literal: true

module Asaas
  module Resources
    # The same payments API with a summarized response body: /lean/payments.
    class LeanPayment < Base
      def self.resource_path = "/lean/payments"

      def self.restore(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/restore", {}, opts)
      end

      def self.refund(id, params = {}, opts = {})
        request_object(:post, "#{resource_path}/#{id}/refund", params, opts)
      end

      def self.capture(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/captureAuthorizedPayment", {}, opts)
      end

      def self.receive_in_cash(id, params = {}, opts = {})
        request_object(:post, "#{resource_path}/#{id}/receiveInCash", params, opts)
      end

      def self.undo_received_in_cash(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/undoReceivedInCash", {}, opts)
      end
    end
  end
end
