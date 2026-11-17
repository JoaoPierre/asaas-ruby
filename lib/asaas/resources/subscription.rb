# frozen_string_literal: true

module Asaas
  module Resources
    class Subscription < Base
      def self.resource_path = "/subscriptions"

      def self.payments(id, params = {}, opts = {})
        path = "#{resource_path}/#{id}/payments"
        response = client(opts).request(:get, path, params: params)
        ListObject.construct_from(response, client: client(opts), path: path, params: params)
      end

      def self.update_credit_card(id, params = {}, opts = {})
        request_object(:post, "#{resource_path}/#{id}/updateCreditCard", params, opts)
      end

      # The payment book (carnê) as a PDF binary String.
      def self.payment_book(id, params = {}, opts = {})
        request_raw("#{resource_path}/#{id}/paymentBook", params, opts)
      end

      def self.invoices(id, params = {}, opts = {})
        request_list("#{resource_path}/#{id}/invoices", params, opts)
      end

      def self.invoice_settings(id, opts = {})
        request_object(:get, "#{resource_path}/#{id}/invoiceSettings", {}, opts)
      end

      def self.create_invoice_settings(id, params = {}, opts = {})
        request_object(:post, "#{resource_path}/#{id}/invoiceSettings", params, opts)
      end

      def self.update_invoice_settings(id, params = {}, opts = {})
        request_object(:put, "#{resource_path}/#{id}/invoiceSettings", params, opts)
      end

      def self.delete_invoice_settings(id, opts = {})
        request_object(:delete, "#{resource_path}/#{id}/invoiceSettings", {}, opts)
      end
    end
  end
end
