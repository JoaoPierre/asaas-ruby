# frozen_string_literal: true

module Asaas
  module Resources
    class Dunning < Base
      def self.resource_path = "/paymentDunnings"

      def self.resend_documents(id, opts = {})
        response = client(opts).request(:post, "#{resource_path}/#{id}/documents")
        AsaasObject.construct_from(response)
      end

      def self.simulate(params = {}, opts = {})
        request_object(:post, "#{resource_path}/simulate", params, opts)
      end

      def self.cancel(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/cancel", {}, opts)
      end

      def self.history(id, params = {}, opts = {})
        request_list("#{resource_path}/#{id}/history", params, opts)
      end

      def self.partial_payments(id, params = {}, opts = {})
        request_list("#{resource_path}/#{id}/partialPayments", params, opts)
      end

      def self.payments_available(params = {}, opts = {})
        request_list("#{resource_path}/paymentsAvailableForDunning", params, opts)
      end
    end
  end
end
