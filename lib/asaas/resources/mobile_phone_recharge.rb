# frozen_string_literal: true

module Asaas
  module Resources
    class MobilePhoneRecharge < Base
      def self.resource_path = "/mobilePhoneRecharges"

      def self.cancel(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/cancel", {}, opts)
      end

      # The carrier of a number and the values it accepts.
      def self.provider(phone_number, opts = {})
        request_object(:get, "#{resource_path}/#{phone_number}/provider", {}, opts)
      end
    end
  end
end
