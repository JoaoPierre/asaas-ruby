# frozen_string_literal: true

module Asaas
  module Resources
    class Payment < Base
      def self.resource_path = "/payments"

      def self.restore(id, opts = {})
        response = client(opts).request(:post, "#{resource_path}/#{id}/restore")
        AsaasObject.construct_from(response)
      end

      def self.refund(id, params = {}, opts = {})
        response = client(opts).request(
          :post,
          "#{resource_path}/#{id}/refund",
          params: params,
          retryable: opts.fetch(:retryable, true),
          timeout: opts[:timeout],
          idempotency_key: opts[:idempotency_key]
        )
        AsaasObject.construct_from(response)
      end

      def self.refunds(id, params = {}, opts = {})
        request_list("#{resource_path}/#{id}/refunds", params, opts)
      end

      def self.refund_bank_slip(id, params = {}, opts = {})
        request_object(:post, "#{resource_path}/#{id}/bankSlip/refund", params, opts)
      end

      # Captures a card payment created with pre-authorization (authorizeOnly).
      def self.capture(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/captureAuthorizedPayment", {}, opts)
      end

      def self.pay_with_card(id, params = {}, opts = {})
        request_object(:post, "#{resource_path}/#{id}/payWithCard", params, opts)
      end

      def self.pay_with_credit_card(id, params = {}, opts = {})
        request_object(:post, "#{resource_path}/#{id}/payWithCreditCard", params, opts)
      end

      def self.receive_in_cash(id, params = {}, opts = {})
        request_object(:post, "#{resource_path}/#{id}/receiveInCash", params, opts)
      end

      def self.confirm_cash_receipt(id, params = {}, opts = {}) = receive_in_cash(id, params, opts)

      def self.undo_received_in_cash(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/undoReceivedInCash", {}, opts)
      end

      def self.billing_info(id, opts = {})
        request_object(:get, "#{resource_path}/#{id}/billingInfo", {}, opts)
      end

      def self.payment_info(id, opts = {}) = billing_info(id, opts)

      def self.viewing_info(id, opts = {})
        request_object(:get, "#{resource_path}/#{id}/viewingInfo", {}, opts)
      end

      def self.status(id, opts = {})
        request_object(:get, "#{resource_path}/#{id}/status", {}, opts)
      end

      def self.identification_field(id, opts = {})
        request_object(:get, "#{resource_path}/#{id}/identificationField", {}, opts)
      end

      def self.pix_qr_code(id, opts = {})
        response = client(opts).request(:get, "#{resource_path}/#{id}/pixQrCode")
        AsaasObject.construct_from(response)
      end

      def self.simulate(params = {}, opts = {})
        request_object(:post, "#{resource_path}/simulate", params, opts)
      end

      def self.limits(opts = {})
        request_object(:get, "#{resource_path}/limits", {}, opts)
      end

      def self.chargeback(id, opts = {})
        request_object(:get, "#{resource_path}/#{id}/chargeback", {}, opts)
      end

      def self.escrow(id, opts = {})
        request_object(:get, "#{resource_path}/#{id}/escrow", {}, opts)
      end

      def self.contractual_effect_restrictions(id, opts = {})
        request_object(:get, "#{resource_path}/#{id}/contractualEffectRestrictions", {}, opts)
      end

      # Documents attached to a payment (multipart: pass `file` as any IO).
      def self.upload_document(id, params = {}, opts = {})
        request_object(:post, "#{resource_path}/#{id}/documents", params, opts)
      end

      def self.documents(id, params = {}, opts = {})
        request_list("#{resource_path}/#{id}/documents", params, opts)
      end

      def self.retrieve_document(id, document_id, opts = {})
        request_object(:get, "#{resource_path}/#{id}/documents/#{document_id}", {}, opts)
      end

      def self.update_document(id, document_id, params = {}, opts = {})
        request_object(:put, "#{resource_path}/#{id}/documents/#{document_id}", params, opts)
      end

      def self.delete_document(id, document_id, opts = {})
        request_object(:delete, "#{resource_path}/#{id}/documents/#{document_id}", {}, opts)
      end
    end
  end
end
