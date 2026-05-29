# frozen_string_literal: true

module Asaas
  module Resources
    class PaymentLink < Base
      def self.resource_path = "/paymentLinks"

      def self.add_image(id, params = {}, opts = {})
        response = client(opts).request(:post, "#{resource_path}/#{id}/images", params: params)
        AsaasObject.construct_from(response)
      end
    end
  end
end
