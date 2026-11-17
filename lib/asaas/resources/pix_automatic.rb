# frozen_string_literal: true

module Asaas
  module Resources
    class PixAutomatic < Base
      def self.resource_path = "/pix/automatic/authorizations"

      # Each charge an authorization schedules is a payment instruction.
      def self.payment_instructions(params = {}, opts = {})
        request_list("/pix/automatic/paymentInstructions", params, opts)
      end

      def self.retrieve_payment_instruction(id, opts = {})
        request_object(:get, "/pix/automatic/paymentInstructions/#{id}", {}, opts)
      end

      # Retries a refused instruction on a new due date: params { dueDate: "2026-12-01" }.
      def self.retry_payment_instruction(id, params = {}, opts = {})
        request_object(:post, "/pix/automatic/paymentInstructions/#{id}/retries", params, opts)
      end
    end
  end
end
