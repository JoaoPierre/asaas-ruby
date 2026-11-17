# frozen_string_literal: true

module Asaas
  module Resources
    class Checkout < Base
      def self.resource_path = "/checkouts"

      def self.cancel(id, opts = {})
        request_object(:post, "#{resource_path}/#{id}/cancel", {}, opts)
      end
    end
  end
end
