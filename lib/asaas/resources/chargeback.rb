# frozen_string_literal: true

module Asaas
  module Resources
    class Chargeback < Base
      def self.resource_path = "/chargebacks"

      def self.dispute(id, params = {}, opts = {})
        response = client(opts).request(:post, "#{resource_path}/#{id}/disputes", params: params)
        AsaasObject.construct_from(response)
      end
    end
  end
end
