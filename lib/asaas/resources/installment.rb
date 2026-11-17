# frozen_string_literal: true

module Asaas
  module Resources
    class Installment < Base
      def self.resource_path = "/installments"

      def self.update_splits(id, params = {}, opts = {})
        response = client(opts).request(:put, "#{resource_path}/#{id}/splits", params: params)
        AsaasObject.construct_from(response)
      end

      def self.payments(id, params = {}, opts = {})
        request_list("#{resource_path}/#{id}/payments", params, opts)
      end

      # Cancels the installment's pending and overdue payments.
      def self.cancel_payments(id, opts = {})
        request_object(:delete, "#{resource_path}/#{id}/payments", {}, opts)
      end

      def self.refund(id, params = {}, opts = {})
        request_object(:post, "#{resource_path}/#{id}/refund", params, opts)
      end

      # The payment book (carnê) as a PDF binary String.
      def self.payment_book(id, params = {}, opts = {})
        request_raw("#{resource_path}/#{id}/paymentBook", params, opts)
      end
    end
  end
end
