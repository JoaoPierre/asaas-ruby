# frozen_string_literal: true

module Asaas
  module Resources
    class Sandbox < Base
      def self.resource_path = "/sandbox"

      def self.approve_account(opts = {})
        response = client(opts).request(:post, "#{resource_path}/myAccount/approve")
        AsaasObject.construct_from(response)
      end

      def self.confirm_payment(id, opts = {})
        response = client(opts).request(:post, "#{resource_path}/payment/#{id}/confirm")
        AsaasObject.construct_from(response)
      end

      def self.overdue_payment(id, opts = {})
        response = client(opts).request(:post, "#{resource_path}/payment/#{id}/overdue")
        AsaasObject.construct_from(response)
      end
    end
  end
end
