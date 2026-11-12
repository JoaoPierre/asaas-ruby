# frozen_string_literal: true

module Asaas
  module Resources
    class Transfer < Base
      def self.resource_path = "/transfers"

      # Cancels a transfer that hasn't reached the bank yet.
      def self.cancel(id, opts = {})
        response = client(opts).request(:delete, "#{resource_path}/#{id}/cancel", **request_options(opts))
        AsaasObject.construct_from(response)
      end
    end
  end
end
