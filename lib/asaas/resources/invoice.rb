# frozen_string_literal: true

module Asaas
  module Resources
    class Invoice < Base
      def self.resource_path = "/invoices"

      # Issues a scheduled invoice now.
      def self.authorize(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/authorize", {}, opts)
      end

      def self.cancel(id, params = {}, opts = {})
        request_object(:post, "#{resource_path}/#{id}/cancel", params, opts)
      end
    end
  end
end
