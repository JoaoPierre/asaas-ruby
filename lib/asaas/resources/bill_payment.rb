# frozen_string_literal: true

module Asaas
  module Resources
    class BillPayment < Base
      def self.resource_path = "/bill"

      def self.simulate(params = {}, opts = {})
        request_object(:post, "#{resource_path}/simulate", params, opts)
      end

      def self.cancel(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/cancel", {}, opts)
      end
    end
  end
end
